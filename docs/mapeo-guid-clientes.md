# Mapeo GUID — Clientes del portal ↔ Empresas de Adm Cloud

**PR-1 · Fase B.** Cruce de los 38 clientes del portal (`clientes`) contra las 87 empresas de Adm Cloud (API).

**Identidad (aprendizaje del PR-1):** el `cliente_id` canónico del portal es el **UUID propio** de `clientes.id` (existe para los 38). El **`adm_cloud_id` (GUID)** es un **enlace opcional** que solo llevan los clientes que están en Adm Cloud. 2 clientes no tienen Adm Cloud (Centro Adorartes se devolvió; Mab usa QuickBooks).

**Estado:** 36 con GUID de Adm Cloud · 2 sin Adm Cloud (legítimo). Validado por Félix 2026-06-07.

---

## Clientes sin empresa en Adm Cloud (adm_cloud_id = null)

| Cliente | Motivo |
|---|---|
| Centro Adorartes | Empezó implementación y se devolvió. No migrado. |
| Mab Arquitectura | Único cliente que usa QuickBooks. |

## Mapeo confirmado (36)

| Cliente portal | portal_id (cliente_id) | → Empresa Adm Cloud | adm_cloud_id (GUID) |
|---|---|---|---|
| Audiobap | `4d18c5bb-8354-438e-bdd9-5220bccb54a5` | Audiobap I, S.R.L. | `84c1b083-5443-43da-8cc6-5715c4ee5da5` |
| Blackbox | `0841e79c-6079-4832-b98f-596918ee338e` | BlackBox Srl | `e4b56115-44fc-437e-9109-b02739121d0b` |
| CLC | `69a7a1e7-8696-491d-81ae-3b30fd019a18` | CLC Salud EIRL | `9ec9a43c-20bc-4576-89cd-e9ba7aea8d1b` |
| Constructora Lidomi | `fb351bc1-715c-4813-8570-042509fcbb3e` | CONSTRUCTORA LIDOMI & ASOCIADOS SRL | `b4fcd4e3-6eb5-4e12-b3c0-3e6be7526da2` |
| Dior Legal | `ca2377c5-1689-4f96-a897-5e357950e6d1` | DIOR LEGAL PARTNERS SRL | `54a48e65-608a-48c3-b3e1-8f813be3d9e8` |
| Dr. Maurice Morel | `25e53a65-f8a2-480e-b837-c1bb456bdbb6` | Dr. Mauricio Morel Radiólogo Vascular e Intervencionista SRL | `236f770b-799b-4f8e-b44b-be22a4b50d5c` |
| Enlaces | `811c6552-f6f6-489b-b3b7-4543d4349339` | Enlaces, Red de inversionistas ángeles | `55def155-1ed8-4efa-8c36-afff69e77cb7` |
| Fleximoney | `44a3a184-f018-428e-8c82-ca9252b63392` | FlexiMoney, SRL | `3fe753e2-7eca-4924-8002-a74329cfcdbb` |
| Gestaf | `fab0e7ef-7d5c-4f6c-bbd4-f3badc1c544d` | Gestaf | `bf513c69-3a61-4d68-5797-08dd3ccd6bb5` |
| Grupisa | `4abab755-75ad-4c49-a08b-770251d68e30` | Grupisa | `ee2f6b8a-e88c-4447-a9b6-8b4ee7fef7d1` |
| Grupo Lisman | `ad24afaa-b99b-4c19-812a-ca59f2be56db` | Grupo Lisman | `3d115663-ab50-4ff9-8da4-1a7aa3bce3d5` |
| Igsan | `4e74c663-a13c-49d2-b7a5-43d47921e599` | IGSAN INTERIOR DESING EIRL | `6035e008-d597-46a5-a6f2-2890dab60223` |
| Impact Logistics | `dfacaed3-bf95-46b8-8af9-cd04d6e448bc` | Impact Logistics  | `712b9b0b-e717-42ae-abc1-adbb2b916500` |
| Iris Laura | `93dfcf87-327b-4700-831e-b55f84a766ea` | Iris Laura Guerrero Diseño de Interiores Srl | `7eddcbf8-11b8-4911-8850-55b64d57b6c3` |
| Kaizen | `5a969078-2cdf-4eb1-b7c8-3d19b90791c0` | KaizenEdu | `c121bd34-1889-4464-b9e4-3bbdb30dace6` |
| Kalma | `7e812586-d41b-49bf-b6a5-307f734aeedb` | Kalma Wellness House | `8b2a0a7e-bba2-483a-ba36-b7a077289b87` |
| La Charpente | `31660b38-2b8a-4cc8-b76a-8990edc5bff1` | La Charpente | `f24f26a5-e6ec-43ca-ac84-ec85a310b8b2` |
| La Fragaria | `b99920eb-bb20-49ee-a522-16f0e40b0321` | La Fragaria Srl | `6b17d593-62eb-4305-9638-ee10e6fab075` |
| Louis Maurice Morel | `0a5260fe-4b10-44c3-aec0-dbf1fa210b6f` | Louis Maurice Morel Ovalle | `6418dcab-3dad-441a-af0f-c78856b2161f` |
| Maria Raquel Bencosme | `34f6712c-7282-4988-b274-080f10ec221d` | Maria Raquel Bencosme | `2782b93d-5732-4afa-b65e-8c801a3eadae` |
| Mj Inversiones | `388ada4a-7b24-4cd6-a0c7-cf66ae4c4d03` | MJ Inversiones Srl  | `a88592ef-ed60-477e-8fe0-b1b4d600d464` |
| MSH | `b88f4482-ad65-4b64-82e7-30e905249290` | MICHELLE SAINT HILAIRE INTERIORISMO SRL | `7fe912b7-02e0-4ddb-af36-aca30612dfbb` |
| Mv Creative | `ab73475c-941d-460c-adea-f70ca1959af1` | Mv Creative Mvc Srl | `8055f2ee-ae83-40ea-b331-d86afab36edf` |
| Nomad | `82dea245-1693-4632-a013-a335b66153ee` | Nomad Srl | `66b12e4f-91e9-49b7-4a5f-08de8066f8d2` |
| Oleica | `9e1bfc2e-56e1-48cb-a8b1-dd016a4c5ef7` | GROWLY BY OLEICA JIMENEZ | `f6a33492-4e36-480b-8ace-0d8ecd0e4fcc` |
| Pimentel Estepan y Asociados | `411a5000-cdad-4582-a2a2-14d162e80d1b` | Pimentel Estepan & Asociados, S.R.L. | `33ebefd2-5a3f-468f-9a4c-4d8ea3bf1fdf` |
| Polux | `7830973d-b226-4e34-b22e-17ed6bc949a1` | Polux Studio Srl | `b13a6bfa-76dc-4f6f-a62f-3e71cd055cb4` |
| PSC | `7bac2094-7abd-4397-84d9-e5b7f5107570` | PSC Estudio de Arquitectura SRL | `985b327b-ed45-41ef-8dc9-adf271231c60` |
| RB Raquel Bencosme | `9305924b-f954-4f27-a37e-1d3dd4e09876` | RB Catering | `4d9a1384-7a7b-46e0-b487-9120a807fa32` |
| SAV | `a4dac8de-4b8c-453d-9e29-351c04d46a70` | SAV Educación y Enseñanza Srl | `eddc9aaf-d8b9-4e8c-9869-38b219d2c157` |
| Sosa Arquitectura | `dce2009c-a146-4a53-bc20-dff7881099f5` | Sosa Arquitectura Mas Construccion Er27sp Srl | `32a4ce58-3927-45a3-aab5-f9251ec58a5f` |
| Suplident | `1f9c149d-86ea-4c04-826c-72369e0cb899` | Suplident | `63d565f2-beed-42f5-8275-f3a0a874ab3e` |
| Tic Tag | `f6f6d35c-fa49-4aa1-9e02-e52b50a7222b` | TIC TAG BY MARIEL TAVAREZ SRL | `d38e582e-3d0e-448b-af34-cc0216e96a2b` |
| Tricargo | `43bb394d-96a5-4b60-b6c8-ebf7de2b06be` | Tri Cargo Beyond Logistics SRL | `b33b3265-f216-4dbb-166c-08deba6b4fdc` |
| Unfold | `d8d17e89-94c1-4109-bcc6-77cbc8dd5d91` | Unfold | `587e9321-4268-446e-8053-d6ee21f2c668` |
| Vitalie | `2c25e14e-393b-4fa5-ac8c-87739ec8f7ce` | Vitalie Centro de Bienestar y  Rejuvenecimiento SRL | `71335d6b-ccc7-4667-b047-d00246143ee0` |

---

*Este mapeo alimenta el PR-4: backfill de `adm_cloud_id` en `clientes` (nullable).*