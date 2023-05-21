import subprocess
import time

# Fonction pour exécuter un script bash et mesurer le temps d'exécution
def run_bash_script(script_path):
    start_time = time.time()
    subprocess.run(["bash", script_path])
    end_time = time.time()
    execution_time = end_time - start_time
    return execution_time

# Exemple d'utilisation
script_path = "./pomegranate-suite.sh"

# Exécutez le script bash et mesurez le temps d'exécution
time_script = run_bash_script(script_path)

# Affichez le temps d'exécution
print(f"Temps d'exécution du script : {time_script} secondes")
