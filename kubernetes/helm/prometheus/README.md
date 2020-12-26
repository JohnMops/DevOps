An open-source monitoring system with a dimensional data model, flexible query language, efficient time series database and modern alerting approach.

Chart: prometheus-community/kube-prometheus-stack

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

1. values.yaml:

We will use this file to control the configuration of our Prometheus. 

This stack has Grafana but I am disabling it to decouple Grafana and Prometheus to control
them both separately.
We will deploy the Grafana chart on its own.

- fullNameOverride: will override the name of the created objects
- nameOverride: we override the label on prometheus objects
- namespaceOverride: override the namespace to deploy prometheus in
- Persistent storage: We will provision a persistent storage for our prometheus

<pre><code>

storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: gp2
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 50Gi
        selector: {}    

</code></pre>

- Service Monitors: 

We are creating a service monitor for our application so that prometheus will know to scrape it

<pre><code>

additionalServiceMonitors:
    - endpoints:
      - interval: 30s
        path: /metrics
        port: prometheus
        scheme: http
      jobLabel: app
      name: guestbook
      namespaceSelector:
        matchNames:
          - app
      selector:
        matchLabels:
          app: guestbook
          tier: frontend

</code></pre>

2. Deploy: 

<pre><code>

kubectl create ns monitoring

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -nmonitoring --values values.yaml

</code></pre>

3. Port forward the service to access prometheus: 

<pre><code>

sudo kubectl -nmonitoring port-forward svc/prometheus-operator-prometheus 9090

</code></pre>

Check localhost:9090 and examine the "Targets" that prometheus is scraping

4. Deploy the application /deployments , /pv, /service

5. Check that the application target is scraped by prometheus as per #3

6. You will see the application targets but the scrape will not work since the sample app we are using
does not expose metrics on the /metrics path for prometheus to scrape