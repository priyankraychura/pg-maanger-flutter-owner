# Mock Database

An in-memory stand-in for the app's NoSQL (DynamoDB) backend. It is the **single
source of truth** for all mock/seed data. Nothing under `features/**` should hold
hardcoded records any more — datasources read from and write to the tables here.

## Layout

```
mock_database/
  mock_database.dart          # MockDatabase singleton — holds the live tables
  tables/                     # one file per table (DynamoDB collection)
    owners_table.dart         #   owner accounts + kPrimaryOwnerId (super admin)
    staff_table.dart          #   manager/helper/admin accounts + per-module permissions
    pgs_table.dart            #   PG properties
    rooms_table.dart          #   rooms  (SSOT for room number / rent)
    beds_table.dart           #   beds   (SSOT for occupancy: which tenant in which bed)
    tenants_table.dart        #   tenants (SSOT for tenant identity)
    payments_table.dart       #   rent / charges
    complaints_table.dart     #   tenant complaints
    leave_notices_table.dart  #   move-out requests
    notices_table.dart        #   announcements
    menus_table.dart          #   14-day meal plan
    wifi_table.dart           #   WiFi networks
    invitations_table.dart    #   join invites
    dashboard_snapshots_table.dart  # precomputed dashboard read-model per PG
```

## Single source of truth

Each fact is typed in exactly one place:

- A **room number** lives only in `rooms_table`.
- A **bed number** and **who occupies it** live only in `beds_table`.
- A **tenant's name / contact** lives only in `tenants_table`.

Denormalized display fields carried on other items (e.g. `tenantName` and
`roomNumber` on a payment, complaint, or bed) are **derived at seed time** from
the owning table rather than retyped, so the mock data can never drift out of
sync. Foreign keys (`pgId`, `tenantId`, `createdBy`, …) are stored as ids and
resolved on read — that is a reference, not duplication.

## DynamoDB mapping

Each table maps to one DynamoDB table. The common access pattern is "list the
items for a PG", so `pgId` is the natural partition key on most tables, with the
item id as the sort key:

| Table            | Partition key | Sort key        |
|------------------|---------------|-----------------|
| pgs              | id            | —               |
| rooms            | pgId          | id (roomId)     |
| beds             | roomId        | id (bedId)      |
| tenants          | pgId          | id (tenantId)   |
| payments         | pgId          | id / month+year |
| complaints       | pgId          | id              |
| leaveNotices     | pgId          | id              |
| notices          | pgId          | id              |
| menus            | pgId          | dayNumber       |
| wifi             | pgId          | id              |
| invitations      | pgId          | id              |
| staff            | id            | — (GSI on pgId) |
| owners           | id            | —               |
| dashboardSnapshots | pgId        | —               |

## Swapping in a real backend

The tables are seeded once (lazily) and kept as mutable growable lists, so mock
create/update/delete persist for the app's lifetime. To go live, replace the
`*_mock_datasource.dart` classes (registered in `injection/service_locator.dart`)
with real DynamoDB-backed implementations of the same repository interfaces —
the widgets, providers and entities do not change.
