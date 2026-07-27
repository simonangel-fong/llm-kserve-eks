# LLM Deployment with KServe & EKS - KServe

[Back](../README.md)

- [LLM Deployment with KServe \& EKS - KServe](#llm-deployment-with-kserve--eks---kserve)
  - [KServe Installation](#kserve-installation)
  - [InferenceService](#inferenceservice)
    - [Test with Open WebUI](#test-with-open-webui)

---

## KServe Installation

```sh
# install cert-manager: required
helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.21.0 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true


# Install CRDs
helm install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd \
  --version v0.18.0 \
  --namespace kserve \
  --create-namespace

# Install KServe Resources: Standard Mode
helm install kserve-resources oci://ghcr.io/kserve/charts/kserve-resources \
  --version v0.18.0 \
  --namespace kserve \
  --set kserve.controller.deploymentMode=Standard \
  --wait

# confirm
kubectl get po -n kserve
# NAME                                         READY   STATUS    RESTARTS   AGE
# kserve-controller-manager-676dbc7ff9-mgsld   2/2     Running   0          51s

```

---

## InferenceService

- Argo CD application: `argocd/apps/kserve-llm.yaml`
- InferenceService manifest: `kserve/inference-qwen2.5.yaml`
- Test:

```sh
# port forward
kubectl port-forward -n llm svc/qwen-llm-predictor 8080:80

# test
curl -X POST http://localhost:8080/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen","messages":[{"role":"user","content":"hello"}]}'
# {"id":"chatcmpl-b7ee3aa748d54b5f","object":"chat.completion","created":1785186894,"model":"qwen","choices":[{"index":0,"message":{"role":"assistant","content":"Hello! How can I assist you today?","refusal":null,"annotations":null,"audio":null,"function_call":null,"tool_calls":[],"reasoning":null},"logprobs":null,"finish_reason":"stop","stop_reason":null,"token_ids":null}],"service_tier":null,"system_fingerprint":null,"usage":{"prompt_tokens":30,"total_tokens":40,"completion_tokens":10,"prompt_tokens_details":null},"prompt_logprobs":null,"prompt_token_ids":null,"kv_transfer_params":null}
```

---

### Test with Open WebUI

```sh
# open webui
kubectl -n open-webui port-forward svc/open-webui 8888:80
```
