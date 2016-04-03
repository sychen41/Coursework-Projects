"""Food categories"""
berries = set(["blueberries","cranberries","raspberries","strawberries"])
vegetables = set(["baked potatos","spinach","peas","celery","broccoli","mushrooms","pickles","cucumber","kale","lettuce","zucchini","eggplant"])
fried = set(["fried fish","fried meat","French fries"])
beans = set(["black bean","white bean","navy bean","lima bean","pinto bean","soy bean","kidney bean","chickpea bean","green bean"])
nuts = set(["walnuts","peanuts","almond","pistachios","cashews"])
fruit = set(["apple","avocado","blueberries","cranberries","raspberries","strawberries","orange","kiwi","pears","banana","melons","peaches","mango","grapefruit","watermelon"])
fish = set(["salmon","tuna","mackerel","fried fish","sardines","halibut","scollops"])

"""Food category map: values are the corresponding set"""
food_category_map = {}
food_category_map['fruit'] = fruit
food_category_map['vegetables'] = vegetables
food_category_map['beans'] = beans
food_category_map['nuts'] = nuts
food_category_map['fish'] = fish
food_category_map['meat'] = set(["meat","fried meat"])

potatos = "baked potatos"
meat = "fried meat"

"""Best food and worst food for each disease"""
diabetes_good = set(["apple","avocado","blueberries","cranberries","raspberries","orange","kiwi","pears","black bean","white bean","navy bean","lima bean","pinto bean","soy bean","salmon","tuna","mackerel","brown rice","brown bread","chicke breast","turkey","eggs","fat free yogurt","unsweetened tea","broccoli","mushrooms","baked potatos","walnuts","peanuts","almond","peaches","cucumber","kale","lettuce","spinach","zucchini","cashews","strawberries"])
diabetes_bad = set(["banana","melons","white bread","white rice","pickles","fried fish","fried meat","sweets","French fries"])

hbp_good = set(["avocade","blueberries","banana","kiwi","orange","peaches","black bean","white bean","navy bean","lima bean","pinto bean","green bean","baked potatos","spinach","peas","celery","broccoli","almonds","pistachios","salmon","tuna","brown rice","brown bread","fat free yogurt","dark chocolate","apple","mango","kale","lettuce","zucchini","mushrooms","walnuts","cashews","strawberries","raspberries"])
hbp_bad = set(["alcohol","soda","fried meat","frozen pizza","pickles"])

ob_good = (berries.union(vegetables)).union(set(["apple","avocado","grapefruit","kiwi","orange","pears","spinach","peas","kale","broccoli","zucchini","mushrooms","black bean", "kidney bean","navy bean","chickpea bean","pinto bean","walnuts","cashews","almonds","salmon","tuna","sardines","halibut"]))
ob_bad = set([potatos,"desserts"]).union(fried)

hch_good = (nuts.union(beans)).union(set(["salmon","spinach","avocado","banana","avocado","grapefruit","kiwi","orange","peaches","mango","spinach","kale","broccoli","zucchini","mushrooms","tuna","scollops","halibut","blueberries","strawberries","raspberries"]))
hch_bad = fried
hch_bad.add(meat)

ibs_good = set(["banana","avocado","grapefruit","kiwi","orange","lettuce","zucchini","eggplant","cucumber","green bean","walnuts","peanuts","almonds","salmon","blueberries","strawberries","raspberries","eggs"])
ibs_bad = set(["apple","pears","watermelon","mango","broccoli","black bean","white bean","cashews","mushrooms","spinach"])

"""A map that contains all information about best and worst food"""
whole_map = {}
whole_map["diabetes_good"] = diabetes_good
whole_map["diabetes_bad"] = diabetes_bad
whole_map["hbp_good"] = hbp_good
whole_map["hbp_bad"] = hbp_bad
whole_map["ob_good"] = ob_good
whole_map["ob_bad"] = ob_bad
whole_map["hch_good"] = hch_good
whole_map["hch_bad"] = hch_bad
whole_map["ibs_good"] = ibs_good
whole_map["ibs_bad"] = ibs_bad

"""Map food to disease"""
disease_map = {}
disease_map["Diabetes"] = ["diabetes_good","diabetes_bad"]
disease_map["High Blood Pressure"] = ["hbp_good","hbp_bad"]
disease_map["Obesity"] = ["ob_good","ob_bad"]
disease_map["High Cholesterol"] = ["hch_good","hch_bad"]
disease_map["Irritable Bowel Syndrome"] = ["ibs_good","ibs_bad"]

"""Hidden attributes that can be inferred given diseases"""
d_hidden = set(["fresh","sugar-free","fat-free","no fried food"])
hbp_hidden = set(["fresh","fat-free","low salt"])
hch_hidden = set(["fresh","fat-free","no meat"])
ob_hidden = set(["no fried food","fat-free","fresh"])
ibs_hidden = set(["fresh","LowFODMAPs"])
hidden_map = {}
hidden_map["Diabetes"] = d_hidden
hidden_map["High Blood Pressure"] = hbp_hidden
hidden_map["Obesity"] = ob_hidden
hidden_map["High Cholesterol"] = hch_hidden
hidden_map["Irritable Bowel Syndrome"] = ibs_hidden


"""Main loop"""
query_type = 0
while query_type != '3':
    user_good_food = []
    user_bad_food = []
    hidden_attributes = []
    print("Choose from two types of queries: ")
    print("1. Food recommendation based on your health condition")
    print("2. Whether a specific food category is good for you")
    print("3. Quit")
    query_type = input('Please give us your choice: ')
    if query_type == '3':
        print("Thanks for using our system.")
        break
    elif query_type == '1':
        print("You chose query type 1\n")
    elif query_type == '2':
        print("You chose query type 2\n ")
    else:
        print("Invalid choice\n")
        continue

    """Gather information from users. Infer hidden attributes, which is the general food principles."""
    """And also generate two collections: one for best food and one for worst food"""
    print("Do you have any of these conditions?")
    for key, value in disease_map.items():
        user_input = input(key + " (y/n): ")
        while user_input != 'y' and user_input != 'n' and user_input != 'Y' and user_input != 'N':
            print(user_input + " is not a valid input. Please try again.")
            user_input = input(key + " (y/n): ")
        if user_input == 'y' or user_input == 'Y':
            user_good_food.append(value[0])
            user_bad_food.append(value[1])
            hidden_attributes.append(key)

    """If user has any of the five health condition, the system will have food recommendation"""
    if len(user_good_food) != 0:
        good_food = whole_map[user_good_food[0]]
        bad_food = whole_map[user_bad_food[0]]
        """By forward chaining, generate worst food list"""
        for choice in user_bad_food:
            bad_food = bad_food.union(whole_map[choice])
        """By forward chaining, generate best food list"""
        for choice in user_good_food:
            good_food = good_food.intersection(whole_map[choice])
        """By forward chaining, generate general food principle"""
        food_principle = hidden_map[hidden_attributes[0]]
        for hidden_attribute in hidden_attributes:
            food_principle = food_principle.intersection(hidden_map[hidden_attribute])
        food_principle = list(food_principle)
        """Prepare a read-friendly version for user"""
        food_principle_str = ""
        for x in range(0, len(food_principle)):
            if x == len(food_principle) - 1 and len(food_principle) != 1:
                food_principle_str += "and "
            food_principle_str += food_principle[x]
            if x != len(food_principle) - 1:
                food_principle_str += ", "

        isempty_good = len(good_food)
        "Query type 1, print result from forward chaining"
        if query_type == '1':
            if isempty_good!=0:
                print("We infer that your food should be: " + food_principle_str)
                print("Food that good for you:")
                print(good_food)

            print("Food you should avoid:")
            print(bad_food)
        """Query type 2, use backward chaining"""
        if query_type == '2':
            interest_food = []
            interest_and_ok_food = {}
            interest_but_notok_food = {}
            print("what food catogories are you interested in?")
            """Ask user about food he/she is interested in."""
            interest_food_categories = ["fish","fruit","vegetables","meat","nuts","beans"]
            for interest_food_category in interest_food_categories:
                interested = input(interest_food_category + "? (y/n): ")
                while interested != 'y' and interested != 'n' and interested != 'Y' and interested != 'N':
                    print(interested + " is not a valid input. Please try again.")
                    interested = input(interest_food_category + "? (y/n): ")
                if interested == 'y' or interested == 'Y':
                    interest_food.append(interest_food_category)

            """By backward chaining, generate result for user"""
            for food_category in interest_food:
                interest_category_ok_food = []
                interest_category_notok_food = []
                for food in food_category_map[food_category]:
                    if food in good_food:
                        interest_category_ok_food.append(food)
                    if food in bad_food:
                        interest_category_notok_food.append(food)
                interest_and_ok_food[food_category] = interest_category_ok_food
                interest_but_notok_food[food_category] = interest_category_notok_food
            """print the result for user"""
            for key, value in interest_and_ok_food.items():
                if len(value)!= 0:
                    print(key + " are good for you, especially " + str(value))
                    if len(interest_but_notok_food[key]) != 0:
                        print("But try to avoid " + str(interest_but_notok_food[key]))
                    print("")
                else:
                    print(key + " are NOT good for you" + '\n')

    else:
        """If user does not have any of the five diseases, we provide some general information about diet"""
        print("You are health! Keep on following normal diet. We recommend fat-free food, fresh fruits and vegetables.")
    print('')


