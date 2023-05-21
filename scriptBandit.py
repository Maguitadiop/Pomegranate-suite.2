import subprocess
import json
import jsonlines
import os

def run_bandit(filepath):
    command = f"bandit -r {filepath} -f json"
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE)
    json_output = result.stdout.decode()
    return json.loads(json_output)

def execute(input_data):
    # Récupération du fichier ou du répertoire à analyser
    input_path = input_data.get('input_path')
    if input_path is None:
        raise ValueError("L'entrée 'input_path' est manquante.")
    
    # Vérification que le fichier ou le répertoire existe
    if not os.path.exists(input_path):
        raise ValueError("Le chemin spécifié n'existe pas : " + input_path)
    
    # Analyse statique avec bandit
    bandit_results = run_bandit(input_path)
    
    # Traitement des résultats pour Pomegranate Suite
    output_data = {'issues': []}
    for issue in bandit_results['results']:
        issue_data = {
            'severity': issue['issue_severity'],
            'description': issue['issue_text'],
            'location': {
                'filename': issue['filename'],
                'line_number': issue['line_number']
            },
            'more_info': issue['more_info']
        }
        output_data['issues'].append(issue_data)
    
    # Écriture du contenu de output_data dans un fichier JSON
    #with open('./reports/bandit-results.json', 'w') as f:
       # jsonlines.dump(output_data, f)
    # Écriture du contenu de output_data dans un fichier JSON
    with open('./reports/bandit-report.jsonl', 'w') as f:
         for issue in output_data['issues']:
            json.dump(issue, f)
            f.write('\n')

    return output_data


if __name__ == "__main__":
    input_data = {'input_path': './apps/MicroBank/'}
    output_data = execute(input_data)
