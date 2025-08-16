kubectl get deployments --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\n"}{end}' \
  | sort -u \
  | grep -vE '^(kube-|openshift-)|^default$' \
  | while read ns; do
      echo "Deleting in namespace: $ns"
      kubectl delete all --all -n "$ns"
      kubectl delete statefulset --all -n "$ns"
      kubectl delete svc --all -n "$ns"
      kubectl delete secret --all -n "$ns"
      kubectl delete namespace "$ns"
    done

