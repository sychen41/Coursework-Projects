berries = set(["blueberries","cranberries","raspberries"])
vegetables = set(["baked potato","spinach","peas","celery","broccoli","mushrooms","pickles"])
fried = set(["fried fish","fried meat","French fries"])
beans = set(["black bean","white bean","navy bean","lima bean","pinto bean","soy bean"])
nuts = set(["walnuts","peanuts","almond","pistachios"])
fruit = set(["apple","avocado","blueberries","cranberries","raspberries","orange","kiwi","pears","banana","melons","peaches"])
fish = set(["salmon","tuna","mackerel","fried fish"])

food_category_map = {}
food_category_map['fruit'] = fruit
food_category_map['vegetables'] = vegetables
food_category_map['beans'] = beans
food_category_map['nuts'] = nuts
food_category_map['fish'] = fish
food_category_map['meat'] = set(["meat","fried meat"])

#common_allergens = "nuts, milk, egg, wheat, soy, fish"

potatos = "baked potatos"
meat = "fried meat"

diabetes_good = set(["apple","avocado","blueberries","cranberries","raspberries","orange","kiwi","pears","black bean","white bean","navy bean","lima bean","pinto bean","soy bean","salmon","tuna","mackerel","brown rice","brown bread","chicke breast","turkey","eggs","fat free yogurt","unsweetened tea","broccoli","mushrooms","baked potato","walnuts","peanuts","almond"])
diabetes_bad = set(["banana","melons","white bread","white rice","pickles","fried fish","fried meat","sweets","French fries"])

hbp_good = set(["avocade","blueberries","banana","kiwi","orange","peaches","black bean","white bean","navy bean","lima bean","pinto bean","green bean","baked potato","spinach","peas","celery","broccoli","almonds","pistachios","salmon","tuna","brown rice","brown bread","fat free yogurt","dark chocolate"])
hbp_bad = set(["alcohol","soda","fried meat","frozen pizza","pickles"])

ob_good = berries.union(vegetables)
ob_bad = set([potatos,"desserts"]).union(fried)

hch_good = (nuts.union(beans)).union(set(["salmon","spinach","avocado"]))
hch_bad = fried
hch_bad.add(meat)

whole_map = {}
whole_map["diabetes_good"] = diabetes_good
whole_map["diabetes_bad"] = diabetes_bad
whole_map["hbp_good"] = hbp_good
whole_map["hbp_bad"] = hbp_bad
whole_map["ob_good"] = ob_good
whole_map["ob_bad"] = ob_bad
whole_map["hch_good"] = hch_good
whole_map["hch_bad"] = hch_bad

#allergies_map = {}
#allergies_map['nuts'] = nuts
#allergies_map['milk'] = set(['fat free yogurt'])
#allergies_map['egg'] = set(['eggs'])
#allergies_map['wheat'] = set(['brown bread'])
#allergies_map['soy'] = beans
#allergies_map['fish'] = set(['salmon', 'tuna', 'mackerel'])

user_good_food = []
user_bad_food = []
#allergies = []

disease_map = {}
disease_map["Diabetes"] = ["diabetes_good","diabetes_bad"]
disease_map["High Blood Pressure"] = ["hbp_good","hbp_bad"]
disease_map["Obesity"] = ["ob_good","ob_bad"]
disease_map["High Cholesterol"] = ["hch_good","hch_bad"]

query_type = 0
while query_type != '3':
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

    print("Do you have any of these conditions?")
    for key, value in disease_map.items():
        user_input = input(key + " (y/n): ")
        while user_input != 'y' and user_input != 'n' and user_input != 'Y' and user_input != 'N':
            print(user_input + " is not a valid input. Please try again.")
            user_input = input(key + " (y/n): ")
        if user_input == 'y' or user_input == 'Y':
            user_good_food.append(value[0])
            user_bad_food.append(value[1])

#    allergies_y_n = input('Are you allergic to ANY of the following food? ' + common_allergens + " (y/n): ")
#    user_allergies = set()
#    if allergies_y_n == "y" or allergies_y_n == "Y":
#        print("which one/ones are you allergic to?")
#        allergies_nuts = input("nuts? (y/n): ")
#        allergies_milk = input("milk? (y/n): ")
#        allergies_egg = input("egg? (y/n): ")
#        allergies_wheat = input("wheat? (y/n): ")
#        allergies_soy = input("soy? (y/n): ")
#        allergies_fish = input("fish? (y/n): ")
#        if allergies_nuts == 'y' or allergies_nuts == 'Y':
#            allergies.append('nuts')
#        if allergies_milk == 'y' or allergies_milk == 'Y':
#            allergies.append('milk')
#        if allergies_egg== 'y' or allergies_egg == 'Y':
#            allergies.append('egg')
#        if allergies_wheat == 'y' or allergies_wheat == 'Y':
#            allergies.append('wheat')
#        if allergies_soy == 'y' or allergies_soy == 'Y':
#            allergies.append('soy')
#        if allergies_fish == 'y' or allergies_fish == 'Y':
#            allergies.append('fish')
#        print(allergies)
#        if (len(allergies)!= 0):
#            user_allergies = allergies_map[allergies[0]]
#            for allergy in allergies:
#                user_allergies = user_allergies.union(allergies_map[allergy])


    if len(user_good_food) != 0:
        good_food = whole_map[user_good_food[0]]
        bad_food = whole_map[user_bad_food[0]]
        for choice in user_bad_food:
            bad_food = bad_food.union(whole_map[choice])
        for choice in user_good_food:
            good_food = good_food.intersection(whole_map[choice]) #- bad_food
            #if len(user_allergies)!= 0:
            #    good_food = good_food - user_allergies

        isempty_good = len(good_food)
        if query_type == '1':
            if isempty_good!=0:
                print("Food that good for you:")
                print(good_food)

            print("Food you should avoid:")
            print(bad_food)
            #print(good_food.intersection(bad_food))
        if query_type == '2':
            interest_food = []
            interest_and_ok_food = {}
            interest_but_notok_food = {}
            print("what food catogories are you interested in?")

            interest_food_categories = ["fish","fruit","vegetables","meat","nuts","beans"]
            for interest_food_category in interest_food_categories:
                interested = input(interest_food_category + "? (y/n): ")
                if interested == 'y' or interested == 'Y':
                    interest_food.append(interest_food_category)

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
            for key, value in interest_and_ok_food.items():
                if len(value)!= 0:
                    print(key + " are good for you, especially " + str(value))
                    if len(interest_but_notok_food[key]) != 0:
                        print("But try to avoid " + str(interest_but_notok_food[key]))
                    print("")
                else:
                    print(key + " are NOT good for you" + '\n')

    else:
        print("You are very health! EAT WHATEVER YOU WANT!") # this is subject to change
    print('')


