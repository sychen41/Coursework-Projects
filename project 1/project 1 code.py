__author__ = 'Shiyi'
import random
import operator
import matplotlib.pyplot as plt
import numpy as np
from math import exp, log

ACONFIGURATION = 'PHPHPHPHPPHPHPPPPHHPPPHPHPPHPPPHPPHPHHPPPHHHHPHPHPPHPHHPHHHHPPHPHPPHPHHPHHPHPHPPHPHHHH'
LENGTH = len(ACONFIGURATION)
print('acid length = ' + str(LENGTH))

A_CONFIG_STR = '01001100111110011011111100010000110001011001000001000101101110010110101010010100000000000110101010101011111010100110011010010100110001001111000101010001000000010110010001'
LENGTHOFCONFIG = len(A_CONFIG_STR)
print('config string length = ' + str(LENGTHOFCONFIG))

def randomizeConfiguration():
    #CONFIGURATION = ['*0*0']
    configurationOrder = ['*0*0']
    configuration_detail = []
    visitedSet = {'*0*0'}
    config = '' #construct config string
    posX = 0
    posY = 0
    backTrackAttempCount = {}
    deadEndFlag = False
    badMove = ''
    iterationCount = 0
    currentLength = 0
    while currentLength < LENGTH:
        iterationCount += 1
        if iterationCount > 1000:
            print('taking too long, terminating')
            return -1
        #for x in range(10):
        dice = random.randint(1,4)
        oldPosX = posX
        oldPosY = posY
        if dice == 1:
            #print("UP")
            if badMove == '01':
                continue
            else:
                posY+=1
        if dice == 2:
            #print("DOWN")
            if badMove == '11':
                continue
            else:
                posY-=1
        if dice == 3:
            #print("LEFT")
            if badMove == '10':
                continue
            else:
                posX-=1
        if dice == 4:
            #print("RIGHT")
            if badMove == '00':
                continue
            else:
                posX+=1

        newPosToStr = '*' + str(posX) + '*' + str(posY) # key has to be unique, so add '*'
        if newPosToStr not in visitedSet:
            badMove = ''
            if dice == 1:
                config += '01'
            if dice == 2:
                config += '11'
            if dice == 3:
                config += '10'
            if dice == 4:
                config += '00'
            configurationOrder.append(newPosToStr)
            visitedSet.add(newPosToStr)
        else:
            upPos = '*' + str(oldPosX) + '*' + str(oldPosY+1)
            downPos = '*' + str(oldPosX) + '*' + str(oldPosY-1)
            leftPos = '*' + str(oldPosX-1) + '*' + str(oldPosY)
            rightPos = '*'+ str(oldPosX+1) +'*'+ str(oldPosY)
            availablePos = []
            availablePosDirectionStr = []
            if upPos not in visitedSet and badMove != '01':
                temp = []
                temp.append(upPos)
                temp.append(oldPosX)
                temp.append(oldPosY+1)
                availablePos.append(temp)
                availablePosDirectionStr.append('01')
            if downPos not in visitedSet and badMove != '11':
                temp = []
                temp.append(downPos)
                temp.append(oldPosX)
                temp.append(oldPosY-1)
                availablePos.append(temp)
                availablePosDirectionStr.append('11')
            if leftPos not in visitedSet and badMove != '10':
                temp = []
                temp.append(leftPos)
                temp.append(oldPosX-1)
                temp.append(oldPosY)
                availablePos.append(temp)
                availablePosDirectionStr.append('10')
            if rightPos not in visitedSet and badMove != '00':
                temp = []
                temp.append(rightPos)
                temp.append(oldPosX+1)
                temp.append(oldPosY)
                availablePos.append(temp)
                availablePosDirectionStr.append('00')
            if len(availablePos) != 0:
                #print('AG')
                badMove = ''
                randomIndex = random.randint(0,len(availablePos)-1)
                config+=availablePosDirectionStr[randomIndex]
                configurationOrder.append(availablePos[randomIndex][0])
                visitedSet.add(availablePos[randomIndex][0])
                posX = availablePos[randomIndex][1]
                posY = availablePos[randomIndex][2]
            else:
                #print("BackTrack")
                #print('configuration')
                #print(CONFIGURATION)
                lastNode = configurationOrder.pop()
                #print('pop')
                #print(CONFIGURATION)
                #print('lastNode')
                #print(lastNode)
                #print('visited')
                #print(visitedSet)
                visitedSet.remove(lastNode)
                #print('node removed from set')
                #print(visitedSet)
                #print('config')
                #print(config)
                lastMove = config[-2] + config[-1]
                #print('lastmove')
                #print(lastMove)
                badMove = lastMove
                tempConfig = ''
                for i in range(0, len(config)-2):
                    tempConfig+=config[i]
                config = tempConfig
                #print('node removed form config str')
                #print(config)
                #print('detail')
                #print(configuration_detail)
                configuration_detail.pop()
                #print('node removed from detail')
                #print(configuration_detail)
                posX = configuration_detail[-1][0]
                posY = configuration_detail[-1][1]
                #print('pos')
                #print(posX)
                #print(posY)
                backTrackNode = configurationOrder[-1]
                #print('go to last node and try again')
                if backTrackNode not in backTrackAttempCount:
                    backTrackAttempCount[backTrackNode] = 1
                elif backTrackAttempCount[backTrackNode] == 10:
                    #print('Max count of attemp reseached. Declare DEAD END')
                    deadEndFlag = True
                    break
                else:
                    backTrackAttempCount[backTrackNode] += 1
                #print(backTrackAttempCount)
                #print("=================================================================")
                continue

                #print(CONFIGURATION)
                #print(VISITED_SET)
                #deadEndFlag = True
                #break

        #print(CONFIGURATION)
        #print(visitedSet)
        node = []
        node.append(posX)
        node.append(posY)
        configuration_detail.append(node)
        currentLength = len(configurationOrder)
        #print(configuration_detail)
        #print(posX)
        #print(posY)
    #print('iteration count:')
    #print(iterationCount)
    if not deadEndFlag:
        #print('one valid configuration generated')
        #print(length)
        #print(config)
        #print(len(config))
        #print(CONFIGURATION)
        #print(visitedSet)
        return config # return configStr
    else:
        #print(CONFIGURATION)
        return -1

def energy(config,visited_map): # config here is config_detail, not configStr
    e = 0 # energy
    length = len(config)
    for i in range(1,length-1):
        if config[i][0] == 'H':
            #print(config[i])
            posX = config[i][1]
            posY = config[i][2]
            upPos = str(posX) + str(posY+1)
            downPos = str(posX) + str(posY-1)
            leftPos = str(posX-1) + str(posY)
            rightPos = str(posX+1) + str(posY)
            # if it's a 'H' node, put into the list
            candidateList = []
            if upPos in visited_map:
                if visited_map[upPos] == 'H':
                    candidateList.append([posX, posY+1])
            if downPos in visited_map:
                if visited_map[downPos] == 'H':
                    candidateList.append([posX, posY-1])
            if leftPos in visited_map:
                if visited_map[leftPos] == 'H':
                    candidateList.append([posX-1, posY])
            if rightPos in visited_map:
                if visited_map[rightPos] == 'H':
                    candidateList.append([posX+1, posY])
            candidateAmount = len(candidateList)
            if candidateAmount != 0:
                #print('found candidate')
                #print(candidateList)
                parentX = config[i-1][1]
                parentY = config[i-1][2]
                childX = config[i+1][1]
                childY = config[i+1][2]
                for candidate in candidateList:
                    trueNeighbor = False
                    candidateX = candidate[0]
                    candidateY = candidate[1]
                    if candidateX == parentX and candidateY == parentY:
                        trueNeighbor = True
                    elif candidateX == childX and candidateY == childY:
                        trueNeighbor = True
                    if trueNeighbor == False: # found topological neighbor
                        #print('found topological neighbor')
                        e-=1
                        #print(e)
    return int(e/2) # double count energy at every pair of topological neighbor


def validation(configStr):
    posX = 0
    posY = 0
    visited_set = {'00'}
    length = len(configStr)
    #print(length)
    for i in range(0, length, 2):
        if configStr[i] == '0':
            if configStr[i+1] == '0': # right
                posX+=1
            elif configStr[i+1] == '1': # up
                posY+=1
        elif configStr[i] == '1':
            if configStr[i+1] == '0': # left
                posX-=1
            elif configStr[i+1] == '1': # down
                posY-=1
        newPosStr = str(posX)+str(posY)
        if newPosStr not in visited_set:
            visited_set.add(newPosStr)
        else:
            return -1 # configuration not valid
        #print(visited_set)
    return 0 #configuation valid

def formatStrToCalEnergy(configStr):
    visited_map = {}
    visited_map['00'] = ACONFIGURATION[0]
    configuration_detail = []
    fakeNodeAtStart = ['F', 0, 0]
    realNodeAtStart = [ACONFIGURATION[0], 0, 0]
    configuration_detail.append(fakeNodeAtStart)
    configuration_detail.append(realNodeAtStart)
    posX = 0
    posY = 0
    indexForAcidType = 1
    length = len(configStr)
    for i in range(0, length, 2):
        if configStr[i] == '0':
            if configStr[i+1] == '0': # right
                posX+=1
            elif configStr[i+1] == '1': # up
                posY+=1
        elif configStr[i] == '1':
            if configStr[i+1] == '0': # left
                posX-=1
            elif configStr[i+1] == '1': # down
                posY-=1
        newPosStr = str(posX)+str(posY)
        visited_map[newPosStr] = ACONFIGURATION[indexForAcidType]
        tempNode = []
        tempNode.append(ACONFIGURATION[indexForAcidType])
        tempNode.append(posX)
        tempNode.append(posY)
        configuration_detail.append(tempNode)
        #print(visited_set)
        indexForAcidType+=1 # fetch next acid
    fakeNodeAtEnd = ['F', posX, posY]
    configuration_detail.append(fakeNodeAtEnd)
    #print(configuration_detail)
    configAndVisitedMap = []
    configAndVisitedMap.append(configuration_detail)
    configAndVisitedMap.append(visited_map)
    return configAndVisitedMap

def pointwiseMutation(configStr):
    #print(configStr)
    length = len(configStr)
    randomIndexList = []
    for x in range(0,3): # mutate max 3 digits in the configuration string for partB, 10 for partC
        randomIndexList.append(random.randint(0,length-1))
    randomIndexList = sorted(list(set(randomIndexList)))
    #print(randomIndexList)
    strList = []
    for i in range(0 ,length):
        strList.append(configStr[i])
    #print(strList)
    for randomIndex in randomIndexList:
        original = strList[randomIndex]
        if original == '0':
            new = '1'
        else:
            new = '0'
        strList[randomIndex] = new
    #print(strList)
    newConfigStr = ''
    for i in range(0, length):
        newConfigStr+=strList[i]
    #print(configStr)
    #print(newConfigStr)
    return newConfigStr

def validPointwiseMutation(configStr):
    newConfigStr = pointwiseMutation(configStr)
    while validation(newConfigStr) != 0:
        newConfigStr = pointwiseMutation(configStr)
    return newConfigStr

#Metropolis algorithm
def metropolisAlg(configStr):
    result = formatStrToCalEnergy(configStr)
    config_detail = result[0]
    visited_map = result[1]
    allConfig_map = {}
    allEnergy_map = {}

    e = energy(config_detail, visited_map)

    for i in range(0,1000):
        newConfigStr = validPointwiseMutation(configStr)
        configStr = newConfigStr
        result = formatStrToCalEnergy(newConfigStr)
        config_detail = result[0]
        visited_map = result[1]
        eNew = energy(config_detail,visited_map)
        t = 4  # temperature, the higher, the more likely to accept by chance
        # accept
        if eNew < e or random.random() < exp(eNew/t*(-1))/exp(e/t*(-1)):
            e = eNew
            if eNew not in allEnergy_map:
                allEnergy_map[eNew] = 1
            else:
                allEnergy_map[eNew] += 1
        else:
            #print("reject")
            continue

    return allEnergy_map

def plotPartB(allEnergy_map):
    energyForAxisX = []
    countOfConfigForAxisY = []
    for key, value in allEnergy_map.items():
        energyForAxisX.append(key)
        countOfConfigForAxisY.append(value)
    print(energyForAxisX)
    print(countOfConfigForAxisY)
    plt.plot(energyForAxisX,countOfConfigForAxisY, 'ro')
    plt.show()

def crossover(configStr1, configStr2):
    length = len(configStr1)
    #randomIndex = random.randint(0,length-1)
    randomIndex = random.randint(1,length-2) # without head and tail can guarantee mutation
    #print(randomIndex)
    newConfigStr1 = ''
    newConfigStr2 = ''
    for i in range(0, randomIndex):
        newConfigStr1+=configStr1[i]
        newConfigStr2+=configStr2[i]
    for i in range(randomIndex,length):
        newConfigStr1+=configStr2[i]
        newConfigStr2+=configStr1[i]
    children = []
    children.append(newConfigStr1)
    children.append(newConfigStr2)
    return children

def geneticAlg(populationSize,maxInterations):
    t = 10 # inital temperature
    #init population of 500 configurations
    population = {}
    p = 0
    attemp = 0
    while p < populationSize:
        if attemp > 10000: # in case some terrible thing happens
            break
        attemp += 1
        randomConfig = randomizeConfiguration()
        #print(randomConfig)
        if randomConfig != -1:
            result = formatStrToCalEnergy(randomConfig)
            config_detail = result[0]
            visited_map = result[1]
            e = energy(config_detail, visited_map)
            #print('energy = ' + str(energy(config_detail,visited_map)))
            population[randomConfig] = e
        # iteration condition update
        p = len(population)

    sortedPop = sorted(population.items(), key=operator.itemgetter(1))
    #print(sortedPop)
    best = sortedPop[0][1]
    print('current best')
    print(best)
    newBest = best
    # now select top 70% percent(fitness) to do pointwise mutation and crossover and generate next generation
    cutMark = int(p*0.7)
    iteration = 1
    lowestEnergy = best
    optimizedConfiguration = sortedPop[0][0]
    while iteration != maxInterations:
        best = newBest
        iteration += 1
        print("=======================================")
        selectedPop = sortedPop[:cutMark]
        #print('selectedPop amount')
        #print(len(selectedPop))

        # pointwise mutation
        mutatedPop = {}
        for configStrAndEnergyPair in selectedPop:
            newConfigStr = pointwiseMutation(configStrAndEnergyPair[0])
            if validation(newConfigStr) == 0: # if mutation is valid, replace the current config
                result = formatStrToCalEnergy(newConfigStr)
                config_detail = result[0]
                visited_map = result[1]
                newEnergy = energy(config_detail, visited_map)
                mutatedPop[newConfigStr] = newEnergy
            else: # if not valid, still use the current one
                mutatedPop[configStrAndEnergyPair[0]] = configStrAndEnergyPair[1]
        #print('mutatedPop amount')
        #print(len(mutatedPop))
        sortedMutatedPop = sorted(mutatedPop.items(), key=operator.itemgetter(1))
        #print('best after pointwise mutation')
        #print(sortedMutatedPop[0][1])
        #print(len(sortedMutatedPop))

        n = 0
        nextGenPop = {}
        # now do crossover to generate next generation
        #print('start crossover')
        while n < p:
            length = len(sortedMutatedPop)
            crossoverAG = True
            aveEngergy = 0
            validChildrenMap = {}
            T = t/log(n+2)
            while crossoverAG:
                #print('crossoverAG')
                randomIndex1 = random.randint(0,length-1)
                randomIndex2 = random.randint(0,length-1)
                config1 = sortedMutatedPop[randomIndex1][0]
                config2 = sortedMutatedPop[randomIndex2][0]
                energy1 = sortedMutatedPop[randomIndex1][1]
                energy2 = sortedMutatedPop[randomIndex2][1]
                aveEngergy = (energy1 + energy2) / 2
                children = crossover(config1, config2)
                for child in children:
                    if validation(child) == 0:
                        crossoverAG = False
                        formatResult = formatStrToCalEnergy(child)
                        config_detail = formatResult[0]
                        visited_map = formatResult[1]
                        validChildrenMap[child] = energy(config_detail,visited_map)
            #print(validChildrenMap)
            #print(aveEngergy)

            #check if child can be added to the new generation
            for child, childEnergy in validChildrenMap.items():
                if childEnergy <= aveEngergy: # Fitness(child) >= average Fitness of two parents
                    #print('direct accept')
                    nextGenPop[child] = childEnergy
                    n+=1
                else:
                    z = random.random()
                    th = exp((-1)*(aveEngergy-childEnergy)/T)
                    #print(z)
                    #print(th)
                    if z < th:
                        #print('accept by chance')
                        nextGenPop[child] = childEnergy
                        n+=1

        sortedPop = sorted(nextGenPop.items(), key=operator.itemgetter(1))
        newBest = sortedPop[0][1]
        if newBest < best:
            lowestEnergy = newBest
            optimizedConfiguration = sortedPop[0][0]
            print('lower energy found')
        else:
            print('no good news, continue next iteration')

    print('max iteration reached, report the optimal configuration and the lowest energy')
    print(lowestEnergy)
    print(optimizedConfiguration)


#MAIN (uncomment to run)

# part A

randomConfig = randomizeConfiguration()
# if 0, then valid
if validation(randomConfig) == 0:
    print('valid')

# part B

#plotPartB(metropolisAlg(A_CONFIG_STR))

# part C: population size 500, iteration 100. feel free to try different combination

#geneticAlg(500,100)





