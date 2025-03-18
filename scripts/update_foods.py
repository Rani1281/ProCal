import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK
cred = credentials.Certificate("")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Function to generate search queries
def create_query_names(name):
    name = name.lower().strip()
    words = name.split()
    names = set()
    
    # Add individual words
    names.update(words)
    
    return list(names)

# Batch update foods with searchQueries
def update_foods_with_query_names(batch_size=500, page_size=1000):
    foods_ref = db.collection('foods')
    last_doc = None
    count = 0

    while True:
        # Paginate the query
        query = foods_ref.order_by('__name__').limit(page_size)
        if last_doc:
            query = query.start_after(last_doc)
        foods = list(query.stream())  # Convert to list to check length

        # Break if no more documents
        if not foods:
            break

        batch = db.batch()

        for food in foods:
            food_data = food.to_dict()
            name = food_data.get('search_name')
            
            # Only update if 'queryNames' doesn't exist
            if name and 'queryNames' not in food_data:
                query_names = create_query_names(name)
                batch.update(food.reference, {'queryNames': query_names})
                count += 1

            # Commit every batch_size writes (Firestore batch limit)
            if count % batch_size == 0:
                batch.commit()
                print(f"Updated {count} foods...")

        # Commit remaining updates in the batch
        batch.commit()
        print(f"Updated {count} foods...")

        # Set last_doc for the next page
        last_doc = foods[-1]

    print(f"Total foods updated: {count}")

if __name__ == "__main__":
    update_foods_with_query_names()
