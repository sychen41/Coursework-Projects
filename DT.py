import math
import operator
from collections import defaultdict, Counter

def load_instances(filename, filter_missing_values=False, missing_value='?'):
    '''Returns a list of instances stored in a file.

    filename is expected to have a series of comma-separated attribute values per line, e.g.,
        p,k,f,n,f,n,f,c,n,w,e,?,k,y,w,n,p,w,o,e,w,v,d'''
    instances = []
    with open(filename, 'r') as f:
        for line in f:
            new_instance = line.strip().split(',')
            if not filter_missing_values or missing_value not in new_instance:
                instances.append(new_instance)
    return instances

def majority_value(instances, class_index=0):
    '''Return the most frequent value of class_index in instances'''
    class_counts = Counter([instance[class_index] for instance in instances])
    return class_counts.most_common(1)[0][0]

def choose_best_attribute_index(instances, candidate_attribute_indexes, class_index=0):
    '''Return the index of the attribute that will provide the greatest information gain
    if instances were partitioned based on that attribute'''
    gains_and_indexes = sorted([(information_gain(instances, i), i) for i in candidate_attribute_indexes],
                               reverse=True)
    return gains_and_indexes[0][1]

def create_decision_tree(instances,
                         candidate_attribute_indexes=None,
                         class_index=0,
                         default_class=None,
                         trace=0):
    '''Returns a new decision tree trained on a list of instances.

    The tree is constructed by recursively selecting and splitting instances based on
    the highest information_gain of the candidate_attribute_indexes.

    The class label is found in position class_index.

    The default_class is the majority value for the current node's parent in the tree.
    A positive (int) trace value will generate trace information
        with increasing levels of indentation.

    Derived from the simplified ID3 algorithm presented in Building Decision Trees in Python
        by Christopher Roach,
    http://www.onlamp.com/pub/a/python/2006/02/09/ai_decision_trees.html?page=3
    '''

    # if no candidate_attribute_indexes are provided,
    # assume that we will use all but the target_attribute_index
    # Note that None != [],
    # as an empty candidate_attribute_indexes list is a recursion stopping condition
    if candidate_attribute_indexes is None:
        candidate_attribute_indexes = [i
                                       for i in range(len(instances[0]))
                                       if i != class_index]
        # Note: do not use candidate_attribute_indexes.remove(class_index)
        # as this would destructively modify the argument,
        # causing problems during recursive calls

    class_labels_and_counts = Counter([instance[class_index] for instance in instances])

    # If the dataset is empty or the candidate attributes list is empty,
    # return the default value
    if not instances or not candidate_attribute_indexes:
        if trace:
            print('{}Using default class {}'.format('< ' * trace, default_class))
        return default_class

    # If all the instances have the same class label, return that class label
    elif len(class_labels_and_counts) == 1:
        class_label = class_labels_and_counts.most_common(1)[0][0]
        if trace:
            print('{}All {} instances have label {}'.format(
                '< ' * trace, len(instances), class_label))
        return class_label
    else:
        default_class = majority_value(instances, class_index)

        # Choose the next best attribute index to best classify the instances
        best_index = choose_best_attribute_index(
            instances, candidate_attribute_indexes, class_index)
        if trace:
            print('{}Creating tree node for attribute index {}'.format(
                    '> ' * trace, best_index))

        # Create a new decision tree node with the best attribute index
        # and an empty dictionary object (for now)
        tree = {best_index:{}}

        # Create a new decision tree sub-node (branch) for each of the values
        # in the best attribute field
        partitions = simple_ml.split_instances(instances, best_index)

        # Remove that attribute from the set of candidates for further splits
        remaining_candidate_attribute_indexes = [i
                                                 for i in candidate_attribute_indexes
                                                 if i != best_index]
        for attribute_value in partitions:
            if trace:
                print('{}Creating subtree for value {} ({}, {}, {}, {})'.format(
                    '> ' * trace,
                    attribute_value,
                    len(partitions[attribute_value]),
                    len(remaining_candidate_attribute_indexes),
                    class_index,
                    default_class))

            # Create a subtree for each value of the the best attribute
            subtree = create_decision_tree(
                partitions[attribute_value],
                remaining_candidate_attribute_indexes,
                class_index,
                default_class,
                trace + 1 if trace else 0)

            # Add the new subtree to the empty dictionary object
            # in the new tree/node we just created
            tree[best_index][attribute_value] = subtree

    return tree

# no missing-value attribute in our data, so we probably don't need to consider it
data_filename = "agaricus-lepiota_p.data"
all_instances = load_instances(data_filename,True)
print('Read', len(all_instances), 'instances from', data_filename)
# we don't want to print all the instances, so we'll just print the first one to verify
print('First instance:', all_instances[0])

training_instances = all_instances[:-5]
test_instances = all_instances[-5:]
