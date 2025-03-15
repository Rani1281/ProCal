import firebase_admin
from firebase_admin import credentials, firestore
from decimal import Decimal
import ijson


FOOD_AMOUNT = 7792
global count
count = 0

def convert_decimals(obj):
    if isinstance(obj, list):
        return [convert_decimals(i) for i in obj]
    elif isinstance(obj, dict):
        return {k: convert_decimals(v) for k, v in obj.items()}
    elif isinstance(obj, Decimal):
        return float(obj)
    else:
        return obj

def get_search_name(food):
    if "description" in food:
        search_name = food["description"].lower()
        search_name = search_name.replace(",", "")
        return search_name
    else:
        return None

def upload_to_firestore(food):
    if isinstance(food, dict):
        food = convert_decimals(food)  # Convert Decimal values to float
        food["search_name"] = get_search_name(food)
        foods_ref = db.collection("foods")
        doc_ref = foods_ref.document()

        if food["search_name"] != None:
            try:
                doc_ref.set(food)
                print(f"Uploaded food")
                count += 1
            except Exception as e:
                print(f"Error uploading food: {e}")
    else:
        raise ValueError("Food item is not a dictionary")



# Initialize Firebase
cred = credentials.Certificate("")
firebase_admin.initialize_app(cred)
db = firestore.client()

print("Initialized Firebase")

# Load json file
try:
    with open("", "r") as f:
        print("File opened successfully")
        items_found = False
        for item in ijson.items(f, "FoundationFoods.item"):
            items_found = True
            print("For item")
            upload_to_firestore(item)
        if not items_found:
            print("No items found in the JSON file")
except FileNotFoundError:
    print("File not found. Please check the file path.")
except Exception as e:
    print(f"An error occurred: {e}")

print("Uploaded foods successfully!")
print(f"{count} foods were uploaded")
print(f"{FOOD_AMOUNT - count} not")