'''
================================================================================================================================
Happie BackEnd Code
================================================================================================================================
'''
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
import coremltools

data = pd.read_csv('Event Feedback 20190716.csv')
data = data.drop(['Timestamp'], axis=1)
cols = list(data.columns)
# print(cols)

'''
================================================================================================================================
Rename Columns
================================================================================================================================
'''
data.columns = ['Gender','Age','Employment','Happiness','Job','Economic','Living','Health','Mental','Soc. Exist','Social']

'''
================================================================================================================================
Categorizing for plotting
================================================================================================================================
'''
happyMale = len(data[(data['Gender'] == 'Male') & (data['Happiness'] >= 7)])
happyFemale = len(data[(data['Gender'] == 'Female') & (data['Happiness'] >= 7)])
happyEmployed = len(data[(data['Employment'] == 'Employed') & (data['Happiness'] >= 7)])
happyUnemployed = len(data[(data['Employment'] == 'Unemployed') & (data['Happiness'] >= 7)])
goodJob = len(data[(data['Job'] >= 7) & (data['Happiness'] >= 7)])
badJob = len(data[(data['Job'] < 7) & (data['Happiness'] >= 7)])
goodEconomic = len(data[(data['Economic'] >= 7) & (data['Happiness'] >= 7)])
badEconomic = len(data[(data['Economic'] < 7) & (data['Happiness'] >= 7)])
healthyHappy = len(data[(data['Health'] > 7) & (data['Happiness'] >= 7)])
sickHappy = len(data[(data['Health'] < 7) & (data['Happiness'] >= 7)])
joyHappy = len(data[(data['Mental'] < 3) & (data['Happiness'] >= 7)])
depressedHappy = len(data[(data['Mental'] > 7) & (data['Happiness'] >= 7)])
existHappy = len(data[(data['Soc. Exist'] == 'Often') & (data['Happiness'] >= 7)])
notExistHappy = len(data[(data['Soc. Exist'] == 'Rarely') & (data['Happiness'] >= 7)])
socialHappy = len(data[(data['Social'] >= 7) & (data['Happiness'] >= 7)])
notSocialHappy = len(data[(data['Social'] < 7) & (data['Happiness'] >= 7)])

# ageGrouping = data.groupby('Age').count()['Gender']
# print(ageGrouping)
# print(data.groupby('Age').count().index)
# print(len(ageGrouping))



'''
================================================================================================================================
Inspecting data types
================================================================================================================================
'''
# print(data.dtypes)

'''
Gender         object
Age             int64
Employment     object
Happiness       int64
Job           float64
Economic        int64
Living          int64
Health          int64
Mental          int64
Soc. Exist     object
Social          int64
'''

'''
================================================================================================================================
Replacing Nan value to 0
================================================================================================================================
'''
data['Job'] = data['Job'].fillna(0)
# print(data['Job'].unique())
# print(data.isnull().sum())

'''
================================================================================================================================
Labeling Gender, Employment, Social Existense
================================================================================================================================
'''
data['Gender'] = data['Gender'].map({
    'Female':0,
    'Male':1
})

data['Employment'] = data['Employment'].map({
    'Unemployed':0,
    'Employed':1
})

data['Soc. Exist'] = data['Soc. Exist'].map({
    'Never (What is social media?)': 0,
    'Rarely': 1,
    'Normal': 2,
    'Often': 3,
    'All the time': 4
})

# print(data['Gender'].unique())
# print(data['Employment'].unique())
# print(data['Soc. Exist'].unique())

# print(data.info())
# print(data.head())
# print(data.tail())
# print(data.describe())

'''
================================================================================================================================
Sorting data Based on Age
================================================================================================================================
'''
# data['Age'] = data['Age'].sort_values()
# data = data.sort_values(['Age'])
# print(data[['Age','Happiness']])
# with pd.option_context('display.max_rows', None, 'display.max_columns', None):  # more options can be specified also
#     print(data[['Age','Happiness']])

'''
================================================================================================================================
Correlation Heatmap
================================================================================================================================
'''
# ax = sns.heatmap(data.corr())
# ax.figure.savefig('heatmapnew.png', transparent=True, bbox_inches='tight')

'''
================================================================================================================================
Splitting data
================================================================================================================================
'''
X = data[['Age','Job','Economic','Living','Health','Mental','Social']]
y = data['Happiness']

from sklearn.model_selection import train_test_split
X_test, X_train, y_test, y_train = train_test_split(
    X,
    y,
    test_size = 0.1,
    # random_state = 1
)

'''
================================================================================================================================
Matplotlib Plot
================================================================================================================================
'''
'''
gender vs happiness
age vs happiness
employment vs happiness
job vs happiness
economic vs happiness
health vs happiness
mental vs happiness
social media existent vs happiness
social vs happiness
'''

plt.figure('Comparation', figsize = (14,7))
plt.subplot(2,5,1)
plt.bar(0, happyMale)
plt.bar(1, happyFemale)
plt.xticks(np.arange(2), ('Male','Female'))
plt.xlabel('Gender')
plt.title('Happy Male vs Happy Female')

plt.subplot(2,5,2)
plt.bar(data.groupby('Age').count().index, data.groupby('Age').count()['Gender'])
plt.title('Age Distribution')
plt.xlabel('Age')
plt.ylabel('Sum for each age in data')

plt.subplot(2,5,3)
plt.bar(np.arange(3,11), data.groupby('Happiness').count()['Gender'])
plt.title('Happiness Distribution')
plt.xlabel('Happiness Index')
plt.ylabel('Sum for each data')

plt.subplot(2,5,4)
plt.bar(0,goodJob)
plt.bar(1, badJob)
plt.title('Job vs Happiness')
plt.xticks(np.arange(2), ('Job+','Job-'))
plt.xlabel('Job Satisfaction')

plt.subplot(2,5,5)
plt.bar(0, goodEconomic)
plt.bar(1, badEconomic)
plt.xticks(np.arange(2), ('Economy+','Economy-'))
plt.xlabel('Economic Level')
plt.title('Economy vs Happiness')

plt.subplot(2,5,6)
plt.bar(0, healthyHappy)
plt.bar(1, sickHappy)
plt.xticks(np.arange(2), ('Health+','Health-'))
plt.xlabel('Fitness Level')
plt.title('Health vs Happiness')

plt.subplot(2,5,7)
plt.bar(0, joyHappy)
plt.bar(1, depressedHappy)
plt.xticks(np.arange(2), ('Joy','Depressed'))
plt.xlabel('Mental Level')
plt.title('Depression vs Happiness')

plt.subplot(2,5,8)
plt.bar(0, existHappy)
plt.bar(1, notExistHappy)
plt.xticks(np.arange(2), ('Often','Rare'))
plt.xlabel('SocMedia Frequency')
plt.title('Social Media vs Happiness')

plt.subplot(2,5,9)
plt.bar(0, socialHappy)
plt.bar(1, notSocialHappy)
plt.xticks(np.arange(2), ('Social+','Social-'))
plt.xlabel('Social Level')
plt.title('Social vs Happiness')

plt.tight_layout()

'''
================================================================================================================================
Seaborn Plot
================================================================================================================================
'''

# sns.pairplot(data)
# sns.distplot(data['Gender'])
# sns.distplot(data['Age'])         # well distributed
# sns.distplot(data['Employment'])
# sns.distplot(data['Job'])
# sns.distplot(data['Economic'])
# sns.distplot(data['Living'])
# sns.distplot(data['Health'])
# sns.distplot(data['Mental'])
# sns.distplot(data['Soc. Exist'])
# sns.distplot(data['Social'])

plt.show()

'''
================================================================================================================================
Machine Learning
================================================================================================================================
'''
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.cluster import KMeans
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier

model = LinearRegression()
model.fit(X_train, y_train)

modelLog = LogisticRegression(solver = 'liblinear', multi_class='ovr')
modelLog.fit(X_train, y_train)

modelKNear = KNeighborsClassifier()
modelKNear.fit(X_train, y_train)

modelKMeans = KMeans()
modelKMeans.fit(X_train,y_train)

modelTree = DecisionTreeClassifier()
modelTree.fit(X_train, y_train)

modelRf = RandomForestClassifier(n_estimators=100)
modelRf.fit(X_train, y_train)


# data['yBest'] = model.predict(
#     data[
#         ['Gender','Age','Employment','Job','Economic','Living','Health','Mental','Soc. Exist','Social']
#         ])
# print(data[['Social','Happiness', 'yBest']].head(25))

# print(data['yBest'].unique())

# predictionLin = model.predict([[0,28,0,10,10,10]])
# print("Happiness index: ", round(predictionLin[0],1))
# print("Score:{}%".format(round(model.score(X_train,y_train)*100,2)))

# predictionLog = modelLog.predict([[0,28,1,10,10,10,10,1,2,10]])
# print("Happiness index: ", round(predictionLog[0],1))
# print("Score:{}%".format(round(modelLog.score(X_train,y_train)*100,2)))

'''
================================================================================================================================
Trial with the best possible outcome
================================================================================================================================
'''
# ['Age','Job','Economic','Living','Health','Mental','Social']

# predictionLin = model.predict([[28,8,7,7,7,3,7]])
# print("Happiness Linear: ", round(predictionLin[0],1))
# print("Score:{}%".format(round(model.score(X_train,y_train)*100,2)))

# predictionLog = modelLog.predict([[28,8,7,7,7,3,7]])
# print("Happiness Logistic: ", round(predictionLog[0],1))
# print("Score:{}%".format(round(modelLog.score(X_train,y_train)*100,2)))

# predictionKNear = modelKNear.predict([[28,8,7,7,7,3,7]])
# print("Happiness KNear: ", round(predictionKNear[0],1))
# print("Score:{}%".format(round(modelKNear.score(X_train,y_train)*100,2)))

# predictionKMeans = modelKMeans.predict([[28,8,7,7,7,3,7]])
# print("Happiness KMeans: ", round(predictionKMeans[0],1))
# print("Score:{}%".format(round(modelKMeans.score(X_train,y_train)*100,2)))

# predictionTree = modelTree.predict([[28,8,7,7,7,3,7]])
# print("Happiness Tree: ", predictionTree[0])
# print("Score:{}%".format(round(modelTree.score(X_train,y_train)*100,2)))

# predictionRf = modelRf.predict([[28,8,7,7,7,3,7]])
# print("Happiness Random Forest: ", round(predictionRf[0],1))
# print("Prediction Score:{}%".format(round(modelRf.score(X_train,y_train)*100,2)))

'''
================================================================================================================================
Trial
================================================================================================================================
'''
# ['Age','Job','Economic','Living','Health','Mental','Social']

# predictionLin = model.predict([[28,7,6,6,6,5,7]])
# print("Happiness Linear: ", round(predictionLin[0],1))
# print("Score:{}%".format(round(model.score(X_train,y_train)*100,2)))

# predictionLog = modelLog.predict([[28,7,6,6,6,5,7]])
# print("Happiness Logistic: ", round(predictionLog[0],1))
# print("Score:{}%".format(round(modelLog.score(X_train,y_train)*100,2)))

# predictionKNear = modelKNear.predict([[28,7,6,6,6,5,7]])
# print("Happiness KNear: ", round(predictionKNear[0],1))
# print("Score:{}%".format(round(modelKNear.score(X_train,y_train)*100,2)))

# predictionKMeans = modelKMeans.predict([[28,7,6,6,6,5,7]])
# print("Happiness KMeans: ", round(predictionKMeans[0],1))
# print("Score:{}%".format(round(modelKMeans.score(X_train,y_train)*100,2)))

# predictionTree = modelTree.predict([[28,7,6,6,6,5,7]])
# print("Happiness Tree: ", predictionTree[0])
# print("Score:{}%".format(round(modelTree.score(X_train,y_train)*100,2)))

# predictionRf = modelRf.predict([[28,7,6,6,6,5,7]])
# print("Happiness Random Forest: ", round(predictionRf[0],1))
# print("Prediction Score:{}%".format(round(modelRf.score(X_train,y_train)*100,2)))

'''
================================================================================================================================
Convert to CoreMl
================================================================================================================================
'''
# from coremltools.converters import sklearn

# coreml_model = coremltools.converters.sklearn.convert(modelLog, ['Age','Job','Economic','Living','Health','Mental','Social'], 'Happiness')
# coreml_model.save('logistic_model.mlmodel')
# coreml_model2 = coremltools.converters.sklearn.convert(modelRf, ['Age','Job','Economic','Living','Health','Mental','Social'], 'Happiness')
# coreml_model2.save('random_forest.mlmodel')
# print('Core ML Model saved')