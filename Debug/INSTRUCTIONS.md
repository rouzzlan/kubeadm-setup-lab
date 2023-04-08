# Debug network from pod
create yaml file and deploy `pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  labels:
    app: ubuntu
spec:
  containers:
    - image: ubuntu
      command:
        - "sleep"
        - "604800"
      imagePullPolicy: IfNotPresent
      name: ubuntu
  restartPolicy: Always
```
deploy
```bash
kubectl apply -f pod.yaml
```
enter the pod's shell
```bash
kubectl exec -it ubuntu -- /bin/bash
```
install required tools
```bash
apt update && apt install iputils-ping curl -y
```