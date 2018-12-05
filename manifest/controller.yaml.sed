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
          imagePullPolicy: {{.image.pull.policy}} 
          command: ["/workspace/entrypoint.sh"]
          args:
            - -l
            - /cached/{{.log}} 
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
            - name: entrypoint
              mountPath: /workspace
              readOnly: true
            - name: cached 
              mountPath: /cached
        - name: logger 
          image: alpine:latest 
          imagePullPolicy: {{.image.pull.policy}} 
          command: ["tail"]
          args:
            - -f
            - /cached/{{.log}} 
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
            - name: entrypoint
              mountPath: /workspace
              readOnly: true
            - name: cached 
              mountPath: /cached
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
        - name: cached 
          emptyDir: {}
