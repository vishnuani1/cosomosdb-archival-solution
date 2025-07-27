
# Azure Billing Records Cost Optimization

This solution implements a **cost optimization strategy** for Azure Cosmos DB in a **read-heavy billing system**, where records older than 90 days are rarely accessed but must remain available for reporting and compliance.

We use **Time-to-Live (TTL)** and **Analytical Store (Synapse Link)** to:
- ✅ Reduce Cosmos DB storage and RU/s costs  
- ✅ Retain historical data without rehydration complexity  
- ✅ Achieve all of this with **no API changes** and **zero downtime**

---

## 🔧 What This Bicep Template Does

The Bicep template located at:

```
bicep/configure-cosmos-container.bicep
```

Performs the following actions **safely and idempotently**:

- Applies a **90-day TTL** to the specified Cosmos DB container  
- Enables **Analytical Store (Synapse Link)** to retain and query archived records  
- Leaves the **existing Cosmos DB account, database, and container** structure untouched  
- Fully **non-destructive** and **production-safe**

---

## 🧠 Smart Cost Optimization Strategy

Instead of enabling Synapse Link across the entire Cosmos DB account (which is expensive), this solution:

- Targets **only the `billing-records` container** where long-term archival is necessary  
- Leaves other containers **unaffected**, avoiding unnecessary analytical storage costs  
- Optimizes cost **without sacrificing** access to cold/archived data  

---

## 🚀 How to Deploy

Use the following command to apply the configuration using **inline parameters**:

```bash
az deployment group create \
  --name configureCosmosContainer \
  --resource-group <your-resource-group> \
  --template-file bicep/configure-cosmos-container.bicep \
  --parameters \
    cosmosDbAccountName='<your-cosmos-account-name>' \
    databaseName='<your-database-name>' \
    containerName='<your-container-name>' \
    ttlInSeconds=7776000 \
    enableAnalyticalStore=true
```

This will:
- Enable **90-day TTL** on the container  
- Enable **Analytical Store** (if not already enabled)  
- Leave existing data and config untouched

---

## 🔍 Querying Archived Data (Synapse Serverless SQL)

Once enabled, historical records (older than 90 days) can be queried using **Synapse Serverless SQL**:

```sql
SELECT * FROM OPENROWSET(
  'CosmosDb',
  'Account=<cosmos-account>;Database=<database>;Container=<container>',
  'SELECT * FROM c WHERE c.billingMonth = "2023-10"'
) AS result
```

- No indexing needed  
- No pre-provisioning required  
- **Pay only for what you read**

---

## ✅ Benefits

- ✅ **No downtime**
- ✅ **No data loss**
- ✅ **No API or read path changes**
- ✅ **Simple to implement and maintain**
- ✅ **Significant cost reduction through container-level archival**

---

## ⚖️ Alternative Consideration: Storage Account-Based Archival

While archival to Azure Blob Storage may provide marginally lower long-term storage costs, it comes with trade-offs:

- ❌ Requires changes to application read paths or API logic  
- ❌ Adds routing logic and maintenance complexity  
- ❌ Introduces latency and possible data duplication issues

**This Synapse Link-based strategy avoids all of the above while remaining cost-effective and API-safe.**



## 🧠 AI Collaboration Log

[📓 Thought Process with ChatGPT →] (https://chatgpt.com/share/6885d4be-d65c-800f-beaa-abd23f677387)  




