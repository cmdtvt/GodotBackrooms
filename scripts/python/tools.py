import json
import random



class UtilityTools():
    def __init__(self,):
        pass

    def randomChance(self,chance):
        chance = 100 - chance
        temp = random.randrange(0,100)

        if temp >= chance:
            return True
        return False

    def procTest(self,amount):
        proc = 0
        for i in range(amount):
            if self.randomChance(1):
                proc += 1

        print("hit "+str(proc)+" times")
        return proc

    def ReadFile(self,filename):
        with open(filename, 'r') as file:
            data = json.load(file)
        return data

    def WriteFile(self,filename:str,data:any):
        temp = json.dumps(data,indent=4)
        with open(filename, 'w') as file:
            file.write(temp)
        return temp

