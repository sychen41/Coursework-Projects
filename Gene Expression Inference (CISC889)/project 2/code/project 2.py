__author__ = 'Shiyi'
training_data_path = "C:\\Users\\Shiyi\\Google Drive\\courses\\889 Advanced AI for BIO\\HW2\\hw2_train.dat"
testing_data_path = "C:\\Users\\Shiyi\\Google Drive\\courses\\889 Advanced AI for BIO\\HW2\\hw2_test.dat"

from dag import DAG, DAGValidationError
from math import log
import random
from copy import copy, deepcopy

#GLOBAL
NUM_GENGS = 6
training_data = []
training_experiments = []
testing_data = []
testing_experiments = []


def inital_graph():
    dag = DAG()
    #dag.from_dict({0:[2],
    #               1:[2,3],
    #               2:[4],
    #               3:[4,5],
    #               4:[],
    #               5:[]})
    dag.from_dict({0:[],
                   1:[],
                   2:[],
                   3:[0,2],
                   4:[0],
                   5:[0,2,3]})
    return dag



def parse_data(data_path):
    data = []
    g0_data = []
    g1_data = []
    g2_data = []
    g3_data = []
    g4_data = []
    g5_data = []
    experiments = []
    data_file = open(data_path, "r")
    data_read = data_file.read().splitlines()
    for line in data_read:
        experiment_data = line.split()
        if len(experiment_data) != 0:
            g0_data.append(int(experiment_data[0]))
            g1_data.append(int(experiment_data[1]))
            g2_data.append(int(experiment_data[2]))
            g3_data.append(int(experiment_data[3]))
            g4_data.append(int(experiment_data[4]))
            g5_data.append(int(experiment_data[5]))
            experiments.append(experiment_data)

    data.append(g0_data)
    data.append(g1_data)
    data.append(g2_data)
    data.append(g3_data)
    data.append(g4_data)
    data.append(g5_data)

    return data, experiments

def cpt_for_one_gene(node,parents):
    all_comb = {}
    one_comb = ''
    total_experiment = len(training_data[0])
    for i in range(0, total_experiment):
        comb = ''
        for parent in parents:
            comb += str(training_data[parent][i])
        if comb not in all_comb:
            if training_data[node][i] == 0:
                all_comb[comb] = [1,0,0]
            else:
                all_comb[comb] = [0,1,0]
        else:
            if training_data[node][i] == 0:
                all_comb[comb][0]+=1
            else:
                all_comb[comb][1]+=1


    for key in all_comb:
        """ all_comb[key][2] = prob of being 1 """
        all_comb[key][2] = all_comb[key][1]*1.0/(all_comb[key][1]+all_comb[key][0])
    return(all_comb)


def cpt_for_all_genes(graph):
    cpt_for_all = []
    for node, edges in graph.graph.iteritems():
        parents = list(graph.predecessors(node))
        cpt_for_all.append(cpt_for_one_gene(node, parents))
    return cpt_for_all

def score(graph):
    cpt = cpt_for_all_genes(graph)
    #print(cpt)
    log_prob_all_experiments = 0
    for experiment in training_experiments:
        log_prob_experiment = 0
        for node, edges in graph.graph.iteritems():
            parents = list(graph.predecessors(node))
            comb = ''
            for parent in parents:
                comb += str(experiment[parent])
            #print(node)
            #print(parents)
            #print(comb)
            #print(cpt[node][comb])
            if experiment[node] == '1':
                log_prob_experiment += log(cpt[node][comb][2])
            else:
                log_prob_experiment += log(1-cpt[node][comb][2])
        #print(log_prob_experiment)
        log_prob_all_experiments += log_prob_experiment
    return log_prob_all_experiments

    #for result_each_gene in experiments[0]:
    #    print(result_each_gene)

def random_two_nodes():
    node1 = random.randint(0,5)
    node2 = random.randint(0,5)
    while node1 == node2:
        node1 = random.randint(0,5)
        node2 = random.randint(0,5)
    return node1, node2



def hw2_part1(max_iterations):
    current_graph = inital_graph()
    current_score = score(current_graph)
    print("current graph:")
    print(print_graph(current_graph))
    print("current score: " + str(current_score))
    #print(score(graph))
    #graph.add_edge(4,5)
    #print(score(graph))
    for x in range(0,max_iterations):
        node1, node2 = random_two_nodes()
        #print(node1)
        #print(node2)
        """ edge addition """
        #print("try add")
        #if the edge DOES NOT exist
        no_need_to_try_deletion = False
        if node2 not in current_graph.graph.get(node1,[]):
            new_graph = deepcopy(current_graph)
            try:
                new_graph.add_edge(node1,node2)
            except DAGValidationError as e: # cycle formed
                #print(type(e))
                pass
            else:
                new_score = score(new_graph)
                if new_score > current_score:
                    current_graph.add_edge(node1,node2)
                    current_score = new_score
                    print('new best found: ' + str(current_score) +
                          " by adding edge(" + str(node1) + "," + str(node2) +")")
                    no_need_to_try_deletion = True

        """ edge deletion """
        if not no_need_to_try_deletion:
            #print("try delete")
            new_graph = deepcopy(current_graph)
            try:
                new_graph.delete_edge(node1,node2)
            except KeyError as e: # no such edge exist
                #print(type(e))
                pass
            else:
                new_score = score(new_graph)
                if new_score > current_score:
                    current_graph.delete_edge(node1,node2)
                    current_score = new_score
                    print('new best found: ' + str(current_score) +
                          " by deleting edge(" + str(node1) + "," + str(node2) +")")

        """ edge reversal: step1: delete the edge. step2: add edge of opposite direction """
        #print("try reversal")
        new_graph = deepcopy(current_graph)
        #delete edge first
        try:
            new_graph.delete_edge(node1,node2)
        except KeyError as e:
            #print(type(e))
            pass
        else:
            try:
                new_graph.add_edge(node2,node1)
            except DAGValidationError as e:
                #print(type(e))
                pass
            else:
                new_score = score(new_graph)
                if new_score > current_score:
                    current_graph.delete_edge(node1,node2)
                    current_score = new_score
                    print('new best found: ' + str(current_score) +
                          " by reversing edge(" + str(node1) + "," + str(node2) +")")
    print(str(max_iterations) + " iterations reached, procedure terminated.")
    print("best score is: " + str(current_score))
    return(current_graph)


def hw2_part2(gene,cpt,graph):
    right_count = 0
    total_count = len(testing_experiments)
    parents = list(graph.predecessors(4))
    for experiment in testing_experiments:
        real_value = int(experiment[gene])
        predicted_value = -1
        comb = ''
        for parent in parents:
            comb += str(experiment[parent])
        #print(cpt[gene])
        #print(cpt[gene][comb])
        #print(cpt[gene][comb][2])
        if cpt[gene][comb][2] > 0.5:
            predicted_value = 1
        else:
            predicted_value = 0
        if real_value == predicted_value:
            right_count += 1
    return right_count*1.0/total_count



def print_graph(graph):
    for node, edges in graph.graph.iteritems():
        print(list(graph.predecessors(node)))


#MAIN
training_data, training_experiments = parse_data(training_data_path)
testing_data, testing_experiments = parse_data(testing_data_path)
print(score(inital_graph()))

"""
best_graph = hw2_part1(6000) # max iterations. Feel free to change it.
cpt_best_graph = cpt_for_all_genes(best_graph)
accuracy = hw2_part2(4,cpt_best_graph,best_graph) # 4 stands for g5
print("The Final Graph:")
print(print_graph(best_graph))
print("Accuracy = " + str(accuracy))
print("CPT:")
for cpt_for_gene in cpt_best_graph:
    print(cpt_for_gene)
#print(cpt_best_graph)
"""
