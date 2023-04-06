# Debug network from pod
create yaml file and deploy
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
enter the pod's shell
```bash
kubectl exec -it ubuntu -- /bin/bash
```
install required tools
```bash
apt update && apt install iputils-ping curl -y
```