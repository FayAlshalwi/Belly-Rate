from urllib import response
from flask import Flask, jsonify, request
import json
import numpy as np
import pandas as pd
import csv
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import scipy.sparse
import matplotlib.pyplot as plt
import seaborn as sns
from surprise import Dataset
from surprise import Reader
from surprise import SVD, SlopeOne, CoClustering, KNNBasic, KNNWithMeans, KNNWithZScore
from surprise.model_selection import cross_validate
import difflib
import random
response = ''
app = Flask(__name__)


data = pd.read_csv('rating_final-2.csv')
data.head()

data.info()

location_data = pd.read_csv('geoplaces2.csv')
location_data.head()

location_data.info()

data = pd.merge(data, location_data[['placeID', 'name']], on='placeID')
data = data[['userID', 'placeID' ,'name', 'rating']]

# load the first 5 rows
data.head()

# Provide a score to each restaurant based on the count of their occurrence, i.e the place that occurs the most is more popular hence, scored high.
placeID_count = data.groupby('placeID').count()['userID'].to_dict()
data['placeScore'] = data['placeID'].map(placeID_count)

# generate top 10 recommendations
top_10_recommendations = pd.DataFrame(data['placeID'].value_counts()).reset_index().rename(columns = {'index' : 'placeID', 'placeID' : 'placeScore'}).iloc[ : 10]
top_10_recommendations = pd.merge(data[['placeID','name']], top_10_recommendations, on='placeID', how='right').drop_duplicates()

# Top 10 Recommendations
top_10_recommendations

# drop the placeScore
data = data.drop('placeScore', axis=1)
data.head()

# Create a reader object
reader = Reader(rating_scale=(0,5)) # The Reader class is used to parse a file containing ratings.
rating_data = Dataset.load_from_df(data[['userID', 'placeID', 'rating']], reader)

# using Singular Value Decomposition (Matrix Factorisation) to build the recommender system
svd = SVD(verbose=True, n_epochs=100)
svd_results = cross_validate(svd, rating_data, measures=['RMSE', 'MAE'], cv=3, verbose=True)


# 1. Get the restaurant id from restaurant name
def get_rest_id(rest_name, data):
    
    '''Returns the Restaurant ID (placeID) given the restaurant Name.'''
    
    rest_names = list(data['name'].values)
    
    # Using difflib find the restaurants that are closest to the input and extract the corresponding placeID
    
    closest_names = difflib.get_close_matches(rest_name, rest_names)
    rest_id = data[data['name'] == closest_names[0]]['placeID'].iloc[0]
    
    return rest_id

# 2. Predict the rating for this restaurant for a given user (b/w 0-2)
def predict_rating(user_id, rest_name, data, model=SVD):
    
    # extract the restaurant id from the restaurant name
    rest_id = get_rest_id(rest_name, data)
    #print(rest_id)
    
    # make predictions
    estimated_ratings = model.predict(uid = user_id, iid = rest_id)
    
    return estimated_ratings.est

# 3. Generate Recommendations for a given user

'''
In this, we will take userID as the input and output the names of all the restaurants for which the given user is most likely to
give a rating above a certain threshold rating (1.5 in this case).
'''
def recommend_restaurants(user_id, data=data, model=svd, threshold=3.4):
    
    # store the recommended restaurants along with the predicted ratings given by the user in a dictionary
    recommended_restaurants = {}
    
    # Find all the unique restaurant names
    unique_rest_names = list(np.unique(data['name'].values))
    
    # Shuffle the restaurant name list
    #random.shuffle(unique_rest_names)
    
    # iterate over the list and generate ratings(predictions) for each restaurant and return only those which have a rating > threshold (1.5)
    for rest_name in unique_rest_names:
        
        # generate predictions
        #print(rest_name)
        rating = predict_rating(user_id=user_id, rest_name=rest_name, data=data, model=svd)
        
        # check if rating > threshold
        if rating > threshold:
            
            recommended_restaurants[rest_name] = np.round(rating,2)
    
    print("Generating Restaurant Recommendations for User ID {} : ".format(user_id))
    
    restaurant_names = np.array(list(recommended_restaurants.keys())).reshape(-1,1)
    restaurant_ratings = np.array(list(recommended_restaurants.values())).reshape(-1,1)
    
    results = np.concatenate((restaurant_names, restaurant_ratings), axis=1)
    results_df = pd.DataFrame(results, columns=['Restaurants', 'Rating (0-2)']).sort_values(by='Rating (0-2)', ascending=False)
    
    return results_df.reset_index().drop('index', axis=1)

#Generate Recommendations using SVD , send userID and receive 3 restaurantID
@app.route('/ratings', methods=['GET', 'POST'])
def rate():  
    global response
    if(request.method == 'POST'):
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        rate = request_data['rating']
        response = f'hi {rate} this is python!'
        with open("rating_final-2.csv", "a") as f:
            csv.writer(f).writerow(rate)
            f.close()
        print("written succesffully")
        return "Done"
    if(request.method == 'GET'):
        # # value from flutter
        print(request.headers.get('usrID'))
        userID = request.headers.get('usrID')
        Recommendations = recommend_restaurants(user_id = userID)
        # Rename columns
        Recommendations.rename(columns = {'Restaurants':'name'}, inplace = True)
        Recommendations.rename(columns = {'Rating (0-2)':'P_Rate'}, inplace = True)
        # merge 
        Recommendations = pd.merge(Recommendations, location_data[['name', 'placeID']], on='name')
        Recommendations = Recommendations.head(3)
        #convert placeID to array
        array = Recommendations['placeID'].values
        if (len(array)==3):
            print("Collaborative Model")
            print(len(array))
            print(array[0])
            print(array[1])
            print(array[2])
            listt = [array[0],array[1],array[2]]
            return json.dumps(listt, cls=NpEncoder)
 
        else:
            #Number of users who have rated a restaurant
            data_grouped = data.groupby('placeID').agg({'userID':'count'}).reset_index()
            data_grouped.rename(columns = {'userID': 'score'}, inplace = True )
            data_sort = data_grouped.sort_values(['score','placeID'], ascending = False)
            #Rank based on scores
            data_sort['Rank'] = data_sort['score'].rank(ascending = 0, method = 'first')
            print('Most popular restaurants')
            print(data_sort['placeID'][0])
            print(data_sort['placeID'][1])
            print(data_sort['placeID'][2])
            array = [data_sort['placeID'][0],data_sort['placeID'][1],data_sort['placeID'][2]]
            return array
  

def write(new):
    with open("rating_final.csv", "a") as f:
        ## add data to csv file
        csv.writer(f).writerow(new)
        ## close the opened csv file
        f.close()


class NpEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        elif isinstance(obj, np.floating):
            return float(obj)
        elif isinstance(obj, np.ndarray):
            return obj.tolist()
        else:
            return super(NpEncoder, self).default(obj)


if __name__ == '__main__':
    app.run()
