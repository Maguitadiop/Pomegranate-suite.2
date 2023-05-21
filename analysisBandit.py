import jsonlines
import collections
from collections import OrderedDict
import os
import json

Number_of_Practises = 6

# Policy Ref: https://bandit.readthedocs.io/en/1.7.5/plugins/index.html 
policy_match_bandit = {
    1: ["Use of exec detected"],
    2: ["Possible binding to all interfaces"],
    3: ["Requests call without timeout"],
    4: ["Possible hardcoded password"],
    5: ["Possible hardcoded secret"],
    6: ["Possible hardcoded credentials"]
}

class Output:
    def __init__(self, title, desc, severity, location):
        self.title = title
        self.desc = desc
        self.severity = severity
        self.location = location

class Results:
    def __init__(self):
        self.final_results = collections.defaultdict(dict)
        self.out = OrderedDict()
        for i in range(1, Number_of_Practises+1):
            self.final_results[i]['status'] = False
            self.out[i] = []

    def set_weakness(self, id, out):
        self.final_results[id]['status'] = True
        self.out[id].append(out)

    def writeOutput(self):
        for i in range(1, Number_of_Practises+1):
            if self.out[i]:
                with open(f'./output/S{i}_bandit.json', 'w') as f:
                    json.dump(self.out[i], f, default=lambda o: o.__dict__, indent=4)

    
    def writeOutputJsonl(self):
        with open('./output/output.jsonl', 'w') as f:
            writer = jsonlines.Writer(f)
            for i in range(1, Number_of_Practises+1):
                if self.out[i]:
                    for item in self.out[i]:
                        writer.write(item.__dict__)
            writer.close()
            
    def get_results(self):
        for i in self.final_results:
            print(self.final_results[i]['status'])

    def get_result(self, id):
        return self.final_results[id]['status']

def parse_bandit(res):
    with open('./reports/bandit-report.jsonl') as f:
        for line in f:
            obj = json.loads(line)
            test_id = obj['description']
            for key, keys in policy_match_bandit.items():
                for k in keys:
                    if k in test_id:
                        o = Output(
                            obj['description'],
                            obj['more_info'],
                            obj['severity'],
                            obj['location']
                            
                        )
                        res.set_weakness(key, o)
                        break
    f.close()

def create_output_directory():
    output_dir = './output/'
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

def create_result_file(res):
    with open(f"./summary_bandit.md", "w") as f:
        with open('./template_table_bandit') as t:
            id = 1
            for num, line in enumerate(t, 1):
                if num <= 2 or id > Number_of_Practises:
                    f.write(line)

                    continue

                status = '&#10004;'

                if res.get_result(id):
                    status = '&#10005;'

                f.write(
                    f"{line[:-1]}{status}|\n")
                id += 1

def main():
    create_output_directory()
    res = Results()
    parse_bandit(res)
    res.writeOutput()
    #res.get_results()
    create_result_file(res)

if __name__ == "__main__":
    main()
