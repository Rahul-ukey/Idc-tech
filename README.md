#Step #1:Create Amazon EKS cluster using eksctl:

aws eks update-kubeconfig --region us-west-2 --name pc-eks 

cluster_name=pc-eks 

oidc_id=$(aws eks describe-cluster --name pc-eks  --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

aws iam list-open-id-connect-providers | grep $oidc_id


eksctl utils associate-iam-oidc-provider --cluster pc-eks --approve



curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json


aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

kubectl create serviceaccount aws-load-balancer-controller -n kube-system


eksctl create iamserviceaccount \
  --cluster=pc-eks  \
  --region=us-west-2 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name "AmazonEKSLoadBalancerControllerRole" \
  --attach-policy-arn=arn:aws:iam::226567608757:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --override-existing-serviceaccounts 

sudo apt install openssl -y

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh


helm repo add eks https://aws.github.io/eks-charts

helm repo update


helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=pc-eks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 

kubectl get deployment -n kube-system aws-load-balancer-controller

kubectl create namespace nlb-sample-app

git clone https://github.com/Rahul-ukey/santa



kubectl events deployment -n kube-system aws-load-balancer-controller


helm create java-chart

helm install java-chart eks-charts/java-chart -f eks-charts/java-chart/values.yaml

helm install java ./java-chart

kubectl get svc 
kubectl get deployment 
kubectl get events -n kube-system
cd java-chart

helm list

helm delete java

kubectl get events 
## Screenshots)
![NLB png](https://github.com/Rahul-ukey/Idc-tech/assets/124550581/287a245e-8bfc-4d3a-9535-ee28d3fe5741)
![Screenshot (51)](https://github.com/Rahul-ukey/Idc-tech/assets/124550581/a86a6a61-c3eb-4c15-a22d-c2bba0e49195)
