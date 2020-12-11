HPA (Horizontal Pod Autoscaler)

Horizontal Pod Autoscaler automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization (or, with beta support, on some other, application-provided metrics).

1. Deploy the HPA for our app:

<pre><code>

kubectl apply -f guestbook-hpa.yml

kubectl -napp get hpa # check the hpa

</code></pre>

-- This should look like this

<pre><code>

NAME        REFERENCE             TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
guestbook   Deployment/frontend   1%/50%    4         10        4          32s


</code></pre>