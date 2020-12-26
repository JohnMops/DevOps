Grafana is a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts for the web when connected to supported data sources

Chart: grafana/grafana

We are going to deploy grafana separately from prometheus and add it as a data source inside grafana.

1.  values.yaml: 

<pre><code>

### Persistent storage configuration:

persistence:
  type: pvc
  enabled: true
  storageClassName: gp2
  accessModes:
    - ReadWriteOnce
  size: 10Gi
  # annotations: {}
  finalizers:
    - kubernetes.io/pvc-protection
  # subPath: ""
  # existingClaim:

</code></pre>

2. Deploy: 

<pre><code>

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

kubectl create ns monitoring

helm upgrade --install grafana  grafana/grafana -nmonitoring --values values.yaml

</code></pre>

3. Get the initial password: 

<pre><code>

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

</code></pre>

4. Port forward (for now, later we will use ingress): 

<pre><code>

# Choose your port on localhost
 
sudo kubectl -nmonitoring port-forward svc/grafana 8000:80

</code></pre>

5. Access localhost:port and enter: 

Username: admin
Password: the value you got from #3

6. Go to Configuration > Data Sources > Add data Source

7. The address of your prometheus service: http://prometheus-operator-prometheus.monitoring.svc:9090

8. Import a dashboard (my choice is https://grafana.com/grafana/dashboards/6417):

Go to Create > Import > Use the ID: 6417 > Click Load > Choose the data source 

9. Go to Dashboards > Manage > Click the dashboard we just imported