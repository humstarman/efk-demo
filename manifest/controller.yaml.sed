kind: Deployment 
apiVersion: extensions/v1beta1
metadata:
  namespace: {{.namespace}} 
  name: {{.name}} 
  labels:
    {{.labels.key}}: {{.labels.value}}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        component: {{.name}} 
    spec:
      containers:
        - name: {{.name}} 
          image: {{.image}} 
          command: ["/workspace/entrypoint.sh"]
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
            - name: entrypoint
              mountPath: /workspace
              readOnly: true
      nodeSelector:
        beta.kubernetes.io/fluentd-ds-ready: "true"
      volumes:
        - name: host-time
          hostPath:
            path: /etc/localtime
        - name: entrypoint 
          configMap:
            name: {{.name}}-config 
            defaultMode: 0755
