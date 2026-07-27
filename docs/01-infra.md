# LLM Deployment with KServe & EKS - EKS Bootstrap

[Back](../README.md)

- [LLM Deployment with KServe \& EKS - EKS Bootstrap](#llm-deployment-with-kserve--eks---eks-bootstrap)
  - [Infra](#infra)
  - [Argo CD](#argo-cd)
  - [GPU node](#gpu-node)

---

## Infra

```sh
terraform -chdir=infra init -backend-config=backend.hcl
terraform -chdir=infra fmt && terraform -chdir=infra validate

terraform -chdir=infra plan
terraform -chdir=infra apply -auto-approve

terraform -chdir=infra destroy

kubectl get node
# NAME                          STATUS   ROLES    AGE     VERSION
# ip-10-0-14-240.ec2.internal   Ready    <none>   2m15s   v1.36.2-eks-bca9cf6
# ip-10-0-20-22.ec2.internal    Ready    <none>   2m12s   v1.36.2-eks-bca9cf6

```

---

## Argo CD

```sh
aws eks update-kubeconfig --region us-east-1 --name kserve-dev
# Added new context arn:aws:eks:us-east-1:099139718958:cluster/kserve-dev to /home/ubuntuadmin/.kube/config

helm list -n argocd
# NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
# argocd  argocd          1               2026-07-27 13:47:04.2911697 -0400 EDT   deployed        argo-cd-10.2.1  v3.4.5

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl -n argocd port-forward svc/argocd-server 8000:443

# app-of-apps
kubectl apply -f argocd/00-root.yaml

```

---

## GPU node

```sh
k get node -l karpenter.sh/nodepool=gpu
# NAME                         STATUS   ROLES    AGE   VERSION
# ip-10-0-13-72.ec2.internal   Ready    <none>   63m   v1.36.2-eks-bca9cf6

# GPU node
k describe node ip-10-0-13-72.ec2.internal
# Name:               ip-10-0-13-72.ec2.internal
# Roles:              <none>
# Labels:             beta.kubernetes.io/arch=amd64
#                     beta.kubernetes.io/instance-type=g6.xlarge
#                     beta.kubernetes.io/os=linux
#                     failure-domain.beta.kubernetes.io/region=us-east-1
#                     failure-domain.beta.kubernetes.io/zone=us-east-1a
#                     k8s.io/cloud-provider-aws=ef42677e4c35899e5732e5b48a646513
#                     karpenter.k8s.aws/ec2nodeclass=gpu
#                     karpenter.k8s.aws/instance-capability-flex=false
#                     karpenter.k8s.aws/instance-category=g
#                     karpenter.k8s.aws/instance-cpu=4
#                     karpenter.k8s.aws/instance-cpu-manufacturer=amd
#                     karpenter.k8s.aws/instance-cpu-sustained-clock-speed-mhz=3400
#                     karpenter.k8s.aws/instance-ebs-bandwidth=5000
#                     karpenter.k8s.aws/instance-encryption-in-transit-supported=true
#                     karpenter.k8s.aws/instance-family=g6
#                     karpenter.k8s.aws/instance-generation=6
#                     karpenter.k8s.aws/instance-gpu-count=1
#                     karpenter.k8s.aws/instance-gpu-manufacturer=nvidia
#                     karpenter.k8s.aws/instance-gpu-memory=22888
#                     karpenter.k8s.aws/instance-gpu-name=l4
#                     karpenter.k8s.aws/instance-hypervisor=nitro
#                     karpenter.k8s.aws/instance-local-nvme=250
#                     karpenter.k8s.aws/instance-memory=16384
#                     karpenter.k8s.aws/instance-network-bandwidth=2500
#                     karpenter.k8s.aws/instance-size=xlarge
#                     karpenter.k8s.aws/instance-tenancy=default
#                     karpenter.sh/capacity-type=on-demand
#                     karpenter.sh/do-not-sync-taints=true
#                     karpenter.sh/initialized=true
#                     karpenter.sh/nodepool=gpu
#                     karpenter.sh/registered=true
#                     kubernetes.io/arch=amd64
#                     kubernetes.io/hostname=ip-10-0-13-72.ec2.internal
#                     kubernetes.io/os=linux
#                     node-role=gpu
#                     node.kubernetes.io/instance-type=g6.xlarge
#                     nvidia.com/gpu.present=true
#                     topology.k8s.aws/zone-id=use1-az4
#                     topology.kubernetes.io/region=us-east-1
#                     topology.kubernetes.io/zone=us-east-1a
# Annotations:        alpha.kubernetes.io/provided-node-ip: 10.0.13.72
#                     karpenter.k8s.aws/ec2nodeclass-hash: 8003911614959956120
#                     karpenter.k8s.aws/ec2nodeclass-hash-version: v5
#                     karpenter.k8s.aws/instance-profile-name: kserve-dev_7090986748062704461
#                     karpenter.sh/nodeclaim-min-values-relaxed: false
#                     karpenter.sh/nodepool-hash: 4925256283347516395
#                     karpenter.sh/nodepool-hash-version: v3
#                     node.alpha.kubernetes.io/ttl: 0
#                     volumes.kubernetes.io/controller-managed-attach-detach: true
# CreationTimestamp:  Mon, 27 Jul 2026 17:08:26 -0400
# Taints:             nvidia.com/gpu:NoSchedule
# Unschedulable:      false
# Lease:
#   HolderIdentity:  ip-10-0-13-72.ec2.internal
#   AcquireTime:     <unset>
#   RenewTime:       Mon, 27 Jul 2026 18:23:11 -0400
# Conditions:
#   Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
#   ----             ------  -----------------                 ------------------                ------                       -------
#   MemoryPressure   False   Mon, 27 Jul 2026 18:19:53 -0400   Mon, 27 Jul 2026 17:08:24 -0400   KubeletHasSufficientMemory   kubelet has sufficient memory available
#   DiskPressure     False   Mon, 27 Jul 2026 18:19:53 -0400   Mon, 27 Jul 2026 17:08:24 -0400   KubeletHasNoDiskPressure     kubelet has no disk pressure
#   PIDPressure      False   Mon, 27 Jul 2026 18:19:53 -0400   Mon, 27 Jul 2026 17:08:24 -0400   KubeletHasSufficientPID      kubelet has sufficient PID available
#   Ready            True    Mon, 27 Jul 2026 18:19:53 -0400   Mon, 27 Jul 2026 17:08:40 -0400   KubeletReady                 kubelet is posting ready status
# Addresses:
#   InternalIP:   10.0.13.72
#   InternalDNS:  ip-10-0-13-72.ec2.internal
#   Hostname:     ip-10-0-13-72.ec2.internal
# Capacity:
#   cpu:                4
#   ephemeral-storage:  104779756Ki
#   hugepages-1Gi:      0
#   hugepages-2Mi:      0
#   memory:             15735928Ki
#   nvidia.com/gpu:     1
#   pods:               58
# Allocatable:
#   cpu:                3920m
#   ephemeral-storage:  95491281146
#   hugepages-1Gi:      0
#   hugepages-2Mi:      0
#   memory:             14719096Ki
#   nvidia.com/gpu:     1
#   pods:               58
# System Info:
#   Machine ID:                 ec22e0a374a9678a40d15c644cebe95b
#   System UUID:                ec22e0a3-74a9-678a-40d1-5c644cebe95b
#   Boot ID:                    022e82cd-fdaf-4bfb-b6ec-d42fd3276aaf
#   Kernel Version:             6.18.38-73.137.amzn2023.x86_64
#   OS Image:                   Amazon Linux 2023.12.20260720
#   Operating System:           linux
#   Architecture:               amd64
#   Container Runtime Version:  containerd://2.2.4+unknown
#   Kubelet Version:            v1.36.2-eks-bca9cf6
# ProviderID:                   aws:///us-east-1a/i-01e58a6fae26a0c9f
# Non-terminated Pods:          (4 in total)
#   Namespace                   Name                            CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
#   ---------                   ----                            ------------  ----------  ---------------  -------------  ---
#   kube-system                 aws-node-rxhnv                  50m (1%)      0 (0%)      0 (0%)           0 (0%)         74m
#   kube-system                 eks-pod-identity-agent-k7ndj    0 (0%)        0 (0%)      0 (0%)           0 (0%)         74m
#   kube-system                 kube-proxy-kd244                100m (2%)     0 (0%)      0 (0%)           0 (0%)         74m
#   kube-system                 nvidia-device-plugin-wgt9v      0 (0%)        0 (0%)      0 (0%)           0 (0%)         74m
# Allocated resources:
#   (Total limits may be over 100 percent, i.e., overcommitted.)
#   Resource           Requests   Limits
#   --------           --------   ------
#   cpu                150m (3%)  0 (0%)
#   memory             0 (0%)     0 (0%)
#   ephemeral-storage  0 (0%)     0 (0%)
#   hugepages-1Gi      0 (0%)     0 (0%)
#   hugepages-2Mi      0 (0%)     0 (0%)
#   nvidia.com/gpu     0          0
# Events:
#   Type    Reason            Age                  From       Message
#   ----    ------            ----                 ----       -------
#   Normal  Unconsolidatable  36m                  karpenter  Not all pods would schedule, llm/qwen-llm-predictor-697b4d58f9-2b2x6 => would schedule against uninitialized nodeclaim/gpu-5tdd7, node/ip-10-0-0-228.ec2.internal
#   Normal  Unconsolidatable  4m47s (x4 over 69m)  karpenter  Can't replace with a cheaper node
```
