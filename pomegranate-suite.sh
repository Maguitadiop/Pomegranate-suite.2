#!/bin/bash

export WRKDIR=/vagrant/home/Pomegranate-suite
# Run docker-bench-security scanner
echo "Running docker-bench-security."
cd tools/docker-bench-security
sudo bash docker-bench-security.sh -p -l docker-bench-report
mv docker-bench-report.json $WRKDIR/reports/
cd $WRKDIR

# Run trivy scanner
echo "Running trivy."
sudo chmod -R 777 /vagrant/home/Pomegranate-suite/reports/
trivy k8s --format json -o $WRKDIR/reports/trivy-results.json minikube --timeout 1h

# Run kube-hunter scanner
kubectl apply -f $WRKDIR/tools/kube-hunter-job.yaml
echo "Waiting for kube-hunter pod ready."
kubectl wait --for=condition=ready pod -l app=kube-hunter --timeout=2m
echo "Waiting for kube-hunter job completed."
kubectl wait --for=condition=complete job/kube-hunter --timeout=10m
POD=$(kubectl get pod -l app=kube-hunter -o jsonpath="{.items[0].metadata.name}")
kubectl logs $POD > $WRKDIR/reports/kube_hunter_report
kubectl delete -f $WRKDIR/tools/kube-hunter-job.yaml

# Run kube-bench scanner
kubectl apply -f $WRKDIR/tools/kube-bench-job.yaml
echo "Waiting for kube-bench pod ready."
kubectl wait --for=condition=ready pod -l app=kube-bench --timeout=2m
echo "Waiting for kube-bench job completed."
kubectl wait --for=condition=complete job/kube-bench --timeout=10m
POD=$(kubectl get pod -l app=kube-bench -o jsonpath="{.items[0].metadata.name}")
kubectl logs $POD > $WRKDIR/reports/kube_bench_report
kubectl delete -f $WRKDIR/tools/kube-bench-job.yaml

# Run OWASP ZAP scanner
echo "Running OWASP ZAP."
docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -t http://$(ip -f inet -o addr show docker0 | awk '{print $4}' | cut -d '/' -f 1):5001 -J zap-report
mv zap-report* $WRKDIR/reports/

# Run NMAP scanner
echo "Running NMAP."
PODIPs=$(kubectl get pods -o=jsonpath="{range .items[*]}{.status.podIP}{' '}{end}")
nmap -sV -p 1-65535 $PODIPs -oX $WRKDIR/reports/nmap-port-report.xml
nmap -sV --script ssl* $PODIPs -oX $WRKDIR/reports/nmap-ssl-report.xml

# Run Terrascan
echo "Running Terrascan."
cd $WRKDIR/apps/MicroBank
terrascan scan -o json > $WRKDIR/reports/terrascan-report.json
cd $WRKDIR

# RUN Bandit
echo "bandit execution."
python3 scriptBandit.py

echo "Automated scan completed."

echo "Started parsing reports."
python3 analysis.py

echo "Started parsing reports bandit."
python3 analysisBandit.py


# git add .
# git commit -m 'Added new results'
# git push origin main
echo "Files are created for refoactoring advises"