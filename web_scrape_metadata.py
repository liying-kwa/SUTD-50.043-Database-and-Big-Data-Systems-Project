from urllib.request import urlopen
import xml.etree.ElementTree as ET
import json
import pandas as pd
import csv
from goodreads import client
import ast
from demjson import decode




def get_the_genre(id):
    genre_list_found = []

    #list of all possible valid genres
    genre_list = ['academia', 'academic', 'adult',
                  'adventure', 'biography', 'classic',
                  'classical', 'classics', 'counselling',
                  'crime', 'fantasy', 'fiction',
                  'historical', 'horror', 'humor',
                  'langauge', 'law', 'mystery',
                  'mystery-thriller', 'non-fiction', 'nonfiction',
                  'over-18', 'religion', 'romance',
                  'sci-fi', 'sci-fi-fantasy', 'science',
                  'science-fiction', 'scifi', 'self-help',
                  'social', 'thriller', 'tourism',
                  'travel', 'war', 'young-adult']

    
    try:
        gc = client.GoodreadsClient('UWKOBM9QcXAw8V1TzcI62g', 'XX8aOKqAjebooLjSWK3Rx8gn2MauCjWgy9IGAIEG4')
        book = gc.book(id)
        shelves_list_raw = book.popular_shelves

        shelves_list = [str(val) for val in shelves_list_raw]
        #print(shelves_list)
        for genre in genre_list:
            if (genre in shelves_list):
                genre_list_found.append(genre)

        #-------clean the genre list-----------------------------
        for index in range(len(genre_list_found)):
            
            if (genre_list_found[index] == 'academia'):
                genre_list_found[index] = 'academic'
            if (genre_list_found[index] == 'classics'):
                genre_list_found[index] = 'classic'
            if (genre_list_found[index] == 'classical'):
                genre_list_found[index] = 'classic'
            if (genre_list_found[index] == 'nonfiction'):
                genre_list_found[index] = 'non-fiction'
            if (genre_list_found[index] == 'scifi'):
                genre_list_found[index] = 'sci-fi'
            if (genre_list_found[index] == 'science-fiction'):
                genre_list_found[index] = 'sci-fi'

        if ('mystery-thriller' in genre_list_found):
            genre_list_found.pop(genre_list_found.index('mystery-thriller'))
            genre_list_found.append('thriller')
            genre_list_found.append('mystery')
        if ('sci-fi-fantasy' in genre_list_found):
            genre_list_found.pop(genre_list_found.index('sci-fi-fantasy'))
            genre_list_found.append('sci-fi')
            genre_list_found.append('fantasy')

        genre_list_found = sorted(genre_list_found)
        genre_list_found = list(dict.fromkeys(genre_list_found))

        #-------end of clean the genre list-----------------------------
                
    except:
        print("There is an error getting genre")


    return genre_list_found



def getMetadata(query):
    
    metadataDict = {}
    
    try:
        queryURL = urlopen(f'https://www.goodreads.com/search.xml?key=UWKOBM9QcXAw8V1TzcI62g&q={query}')
        tree = ET.parse(queryURL)
        root = tree.getroot()
        for book in root.findall('./search/results/work/best_book/id'):
            bookID = (book.text)
            break
        metadataURL = urlopen(f'https://www.goodreads.com/book/show/{bookID}?format=xml&key=UWKOBM9QcXAw8V1TzcI62g')


        tree2 = ET.parse(metadataURL)
        root2 = tree2.getroot()

        author = []
        title = None
        imUrl = None
        description = None
        isbn = None

        
        for val in root2.findall('./book/authors/author/name'):
            author.append(val.text)
        for val in root2.findall('./book/title'):
            title = val.text
        for val in root2.findall('./book/image_url'):
            imUrl = val.text
        for val in root2.findall('./book/description'):
            description = val.text
        for val in root2.findall('./book/isbn13'):
            isbn = val.text

        metadataDict = {
            'title': title,
            'author': ', '.join(author),
            'description': description,
            'imUrl': imUrl,
            'isbn': isbn,
            'bookID': bookID,
        }
    except:
        print("An exception occurred, data can't be found.")
        
    return metadataDict


def make_json(csvFilePath, jsonFilePath): 
      
    #create a dictionary 
    data = {} 
    with open(jsonFilePath, 'w', encoding='utf-8') as jsonf:
        
        with open(csvFilePath, encoding='utf-8') as csvf: 
            csvReader = csv.DictReader(csvf) 

            # Convert each row into a dictionary and add it to data 
            for rows in csvReader: 
                jsonf.write(json.dumps(rows))
                jsonf.write("\n")
                key = rows['asin'] 
                data[key] = rows 



#-----end of functions, start of main code---------------------------------------------




#meta_Kindle_Store.csv is where i use robo3T to convert the json file to csv
df = pd.read_csv('meta_Kindle_Store.csv')
df = df[['asin','imUrl', 'price', 'description']]
df['title'] = None
df['author'] = None
df['isbn'] = None
df['bookID'] = None
df['genre'] = 'No Genre'

print(df.shape)

#purpose here is to divide up the workload
#xm,ly,yz,py

#if you are xm, uncomment the block of code below
#start = 0
#end = 87000
#to_writefile = "new_kindle_metadata0.json"

#if you are ly, uncomment the block of code below
#start = 87000
#end = 2 * 87000
#to_writefile = "new_kindle_metadata1.json"

#if you are yz, uncomment the block of code below
#start = 2 * 87000
#end = 3 * 87000
#to_writefile = "new_kindle_metadata2.json"

#if you are py, uncomment the block of code below
#start = 3 * 87000
#end = 4 * 87000
#to_writefile = "new_kindle_metadata3.json"

#if you are jh, uncomment the block of code below
#start = 4 * 87000
#end = (df.shape)[0]
#to_writefile = "new_kindle_metadata4.json"


df = df[start:end]

for index in range(start, end):

    print(index)
    
    metadata_dict = getMetadata(df['asin'][index])
    if (len(metadata_dict) != 0):        
        #print(metadata_dict)
        
        df['title'][index] = metadata_dict['title']
        df['author'][index] = metadata_dict['author']
        df['isbn'][index] = metadata_dict['isbn']
        df['bookID'][index] = metadata_dict['bookID']

        genres = get_the_genre(int(metadata_dict['bookID']))
        if (len(genres) != 0):
            df['genre'][index] = genres
        
        if (df['description'][index] != df['description'][index]):
            #means NaN, no values
            df['description'][index] = metadata_dict['description']
        
        if (df['imUrl'][index] != df['imUrl'][index]):
            #means NaN, no values
            df['imUrl'][index] = metadata_dict['imUrl']
        



df.to_csv('new_meta_Kindle_Store.csv', index=False)
          

#---------convert csv file into json form----------------------------
csvFilePath = r'new_meta_Kindle_Store.csv'
jsonFilePath = r'temp.json'
  
#Call make_json function 
make_json(csvFilePath, jsonFilePath)
#---------end of convert csv file into json form----------------------



#------to make the json file suitable for importing into mongodb-------
readfile = open("temp.json","r")
writefile = open(to_writefile,"w")
lines = readfile.readlines()

for line in lines:
    writefile.write(str(decode(line)))
    writefile.write("\n")
    #writefile.write(line.replace('"','\''))
readfile.close()
writefile.close()
#------end of to make the json file suitable for importing into mongodb-------




print("done")
