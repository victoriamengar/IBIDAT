# This code uses the Requests library to download the Wikipedia page 
# and BeautifulSoup to parse and extract information from the page content

import requests  
from bs4 import BeautifulSoup

url = "https://es.wikipedia.org/wiki/Universidad_Carlos_III_de_Madrid"

# It makes a GET request to retrieve the Wikipedia page content
page = requests.get(url)  

# It parses the page content using BeautifulSoup
soup = BeautifulSoup(page.content, "html.parser")

# It searches through all text content on the page looking for matches
# of the university name, counting the total matches found
name = "Universidad Carlos III de Madrid"
results = soup.find_all(string=lambda text: name.lower() in text.lower())
print(f"Number of references to {name}: {len(results)}")

# It finds the table tag
table = soup.find("table")

# It finds all th tags inside the table
th_tags = table.find_all("th")

# Function to extract the number of students:

def extract_number_of_students(th_tags):

    # Loop through all th tags
    for th in th_tags:

        # It checks if the th tag contains the desired text
        if "Estudiantes" in th.text:

            # If found, find  inside the td tag
            td_tag = th.find_next("td")

            # Next, extract the text content of the td tag and remove any non-numeric characters
            number_of_students = "".join(filter(str.isdigit, td_tag.text))

            # Finally, it converts the extracted text to an integer
            number_of_students = int(number_of_students)
            return number_of_students

# Calling the function and printing the result
number_of_students = extract_number_of_students(th_tags)
print("Number of students:", number_of_students)