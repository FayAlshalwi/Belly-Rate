from urllib import response
from flask import Flask, jsonify, request
import json
import numpy as np
import pandas as pd
import csv

response = ''
app = Flask(__name__)

data = pd.read_csv('rating_final.csv')

# How many times has a user rated
most_rated_users = data['userID'].value_counts()
most_rated_users

# How many times has a restaurant been rated
most_rated_restaurants = data['placeID'].value_counts()
most_rated_restaurants

# How many users have rated more than n places ?
n = 3
user_counts = most_rated_users[most_rated_users > n]
len(user_counts)
user_counts

# No. of ratings given
user_counts.sum()

# Retrieve all ratings given by the above users from the full data
data_final = data[data['userID'].isin(user_counts.index)]
data_final

# No. of users who have rated a resto
data_grouped = data.groupby('placeID').agg({'userID': 'count'}).reset_index()
data_grouped.rename(columns={'userID': 'score'}, inplace=True)
data_sort = data_grouped.sort_values(['score', 'placeID'], ascending=False)
data_sort.head()

# Let's rank them based on scores
data_sort['Rank'] = data_sort['score'].rank(ascending=0, method='first')
pop_recom = data_sort
pop_recom.head()

print('Here are the most popular restaurants')
pop_recom[['placeID', 'score', 'Rank']].head()

# Transform the data into a pivot table -> Format required for colab model
pivot_data = data_final.pivot(index='userID', columns='placeID', values='rating').fillna(0)
pivot_data.shape
pivot_data.head()

# Create a user_index column to count the no. of users -> Change naming convention of user by using counter
pivot_data['user_index'] = np.arange(0, pivot_data.shape[0], 1)
pivot_data.head()

pivot_data.set_index(['user_index'], inplace=True)
pivot_data.head()

# Applying SVD method on a large sparse matrix -> To predict ratings for all resto that weren't rated by a user
from scipy.sparse.linalg import svds

# SVD
U, s, VT = svds(pivot_data, k=10)

# Construct diagonal array in SVD
sigma = np.diag(s)

# Applying SVD would output 3 parameters namely
print("U = ", U)  # Orthogonal matrix
print('************************************************')
print("S = ", s)  # Singular values
print('************************************************')
print("VT = ", VT)  # Transpose of Orthogonal matrix

# Predict ratings for all restaurants not rated by a user using SVD
all_user_predicted_ratings = np.dot(np.dot(U, sigma), VT)

# Predicted ratings
pred_data = pd.DataFrame(all_user_predicted_ratings, columns=pivot_data.columns)
pred_data.head()



userID = 120
num_recommedations = 5
print(pred_data)
print(userID)
print(userID)
print(userID)
print(pivot_data)

@app.route('/ratings', methods=['GET', 'POST'])
def recommend(userID, pivot_data, pred_data, num_recommendations):  # put application's code here
    global response
    if(request.method == 'POST'):
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        rate = request_data['rating']
        response = f'hi {rate} this is python!'
        with open("rating_final.csv", "a") as f:
            csv.writer(f).writerow(rate)
            f.close()
        return " "
    if(request.method == 'GET'):
        user_index = userID - 1  # index starts at 0
        sorted_user_ratings = pivot_data.iloc[user_index].sort_values(ascending=False)  # sort user ratings
        sorted_user_predictions = pred_data.iloc[user_index].sort_values(ascending=False)  # sorted_user_predictions
        temp = pd.concat([sorted_user_ratings, sorted_user_predictions], axis=1)
        temp.index.name = 'Recommended Places'
        temp.columns = ['user_ratings', 'user_predictions']
        temp = temp.loc[temp.user_ratings == 0]
        temp = temp.sort_values('user_predictions', ascending=False)
        print('\n Below are the recommended places for user(user_id = {}):\n'.format(userID))
        RecommendedPlaces = temp.head(num_recommendations)
        print(temp.head(num_recommendations))
        return jsonify({'recommeneded': temp.head(num_recommendations)})
        # return temp.head(num_recommendations)

userID = 120
num_recommedations = 5
print(pred_data)
print(userID)
print(userID)
print(userID)
print(pivot_data)
recommend(userID, pivot_data, pred_data, num_recommedations)

def write(new):
    with open("rating_final.csv", "a") as f:
        ## add data to csv file
        csv.writer(f).writerow(new)
        ## close the opened csv file
        f.close()

# newData = ["U115", "RAD", 5, 5, 5]
# write(newData)

if __name__ == '__main__':
    app.run()
