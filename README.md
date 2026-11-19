## 1. Product overview

ValetOS helps independent valet companies digitize vehicle check-in,
parking assignment, customer ticketing, vehicle retrieval, payment
collection, and operational reporting.

### Confirmed product decisions

  -----------------------------------------------------------------------
  Area                                Decision
  ----------------------------------- -----------------------------------
  Business model                      Multi-tenant SaaS

  Users                               Customers, attendants, company
                                      managers, platform administrators

  Customer access                     Dedicated mobile app and SMS-linked
                                      mobile web ticket

  Parking management                  Configurable parking labels

  Payments                            Digital payments and
                                      attendant-recorded payments

  SaaS billing                        Monthly subscription per location

  Mobile                              iOS and Android
  -----------------------------------------------------------------------

### Product principles

1.  A parking session is the central operational record.
2.  Vehicle status and payment status are independent.
3.  Customers can access a ticket without creating an account.
4.  Every important operational action is attributable to a user and
    timestamp.
5.  Tenant isolation is enforced on the server and database---not
    trusted to the client.
6.  Ticket access uses a high-entropy, revocable token, not a database
    ID.

## 2. Personas and roles

### Customer

Receives a ticket, views vehicle details, requests retrieval, follows
progress, pays, and receives a receipt.

### Valet attendant

Checks vehicles in, captures condition photos, assigns parking labels,
handles retrieval requests, records permitted payments, and confirms
handoff.

### Company manager

Manages company locations, employees, roles, parking labels, pricing,
operations, reports, and location subscriptions.

### Platform administrator

Onboards and administers tenant organizations, subscription plans,
billing status, and support access.

## 3. MVP scope

### P0 --- Required for pilot

-   Tenant and location provisioning
-   Authentication and role-based authorization
-   Employee invitations and location assignments
-   Vehicle/customer check-in
-   Vehicle condition photo capture
-   Parking label assignment
-   Digital ticket and secure customer web link
-   Customer retrieval request
-   Attendant retrieval queue and atomic request acceptance
-   Ready-for-pickup notification
-   Verified vehicle handoff
-   Session status history and audit trail
-   Active vehicle search and manager dashboard
-   Tenant isolation and automated security tests

### P1 --- Include if pilot timeline permits

-   Digital payment processing
-   Attendant-recorded cash/card-terminal payments
-   Pricing rules and itemized receipts
-   SMS and push notifications
-   Basic daily operational and payment reports
-   Per-location SaaS subscription management

### Out of scope for MVP

-   Automatic license plate recognition
-   AI damage detection
-   GPS vehicle tracking
-   Visual parking maps and space optimization
-   Advance reservations
-   Dynamic pricing
-   Loyalty programs
-   Predictive analytics
-   Accounting integrations

## 4. User journeys

### Journey A --- Check in a vehicle

1.  Attendant selects an authorized operating location.
2.  Attendant starts a new check-in.
3.  Attendant enters customer name and phone number.
4.  Attendant enters plate, make, model, and color.
5.  Attendant captures condition photos and notes.
6.  Attendant saves the check-in.
7.  System creates a parking session and unique ticket.
8.  Attendant assigns a parking label, or the session enters an
    awaiting-parking queue.
9.  System sends an SMS ticket link when a valid phone number is
    available.
10. Attendant can display the QR code or ticket number if SMS delivery
    fails.

**Completion:** session is checked in and traceable. Ticket creation
must not depend on SMS delivery success.

### Journey B --- Park the vehicle

1.  Attendant opens the awaiting-parking queue.
2.  Attendant claims or accepts the task.
3.  Attendant moves the vehicle to a parking location.
4.  Attendant selects a configured label (for example, A-01 or
    Level-2-08).
5.  System validates that the label is available.
6.  Attendant confirms parked.
7.  System records status, parking label, user, and timestamp.

### Journey C --- Retrieve the vehicle

1.  Customer opens the secure ticket.
2.  Customer requests the vehicle.
3.  Backend validates token, session state, and location.
4.  System creates a retrieval request and notifies the location's
    active attendants.
5.  One attendant atomically accepts the request.
6.  Attendant views vehicle details and parking label.
7.  Attendant marks the vehicle as retrieving.
8.  Attendant marks it ready for pickup.
9.  Customer receives an update.
10. Attendant verifies the ticket or another approved identity check.
11. Attendant confirms handoff.
12. System completes the parking session and records the handoff.

**Concurrency:** request acceptance must be atomic; only one attendant
can claim a request.

### Journey D --- Payment and checkout

1.  System calculates the charge using the applicable location pricing
    rule.
2.  Customer pays digitally or an authorized attendant records an
    offline payment.
3.  Digital payment is confirmed by a signed provider webhook.
4.  Offline payment records method, amount, currency, employee, and
    timestamp.
5.  System creates a receipt.
6.  Attendant confirms handoff.
7.  Session closes.

Payment status is separate from operational status. A vehicle may be
ready while payment remains due. Each location configures whether
payment is required before handoff or can be recorded at pickup.

## 5. User stories and acceptance criteria

  -----------------------------------------------------------------------
  ID                      Story                   Acceptance criteria
  ----------------------- ----------------------- -----------------------
  US-001                  As an owner, I can      Organization receives a
                          create my organization. unique ID and initial
                                                  owner membership.

  US-002                  As a manager, I can     Location belongs to the
                          create locations.       manager's organization.

  US-003                  As a manager, I can     Invitation is
                          invite employees.       single-use, expires,
                                                  and assigns a defined
                                                  role.

  US-004                  As a manager, I can     Employee can only
                          assign location access. operate at assigned
                                                  locations.

  US-005                  As an attendant, I can  Required session,
                          check in a vehicle.     customer, and vehicle
                                                  data is persisted.

  US-006                  As an attendant, I can  Photos are linked to
                          capture condition       the session with
                          photos.                 capture metadata.

  US-007                  As an attendant, I can  Unique ticket is
                          issue a ticket.         created and secure
                                                  access link is
                                                  available.

  US-008                  As an attendant, I can  Label belongs to the
                          assign a parking label. selected location and
                                                  cannot be
                                                  double-occupied.

  US-009                  As a customer, I can    Valid token displays
                          view my ticket.         only the associated
                                                  session's allowed
                                                  fields.

  US-010                  As a customer, I can    One active request is
                          request retrieval.      created for the
                                                  session.

  US-011                  As an attendant, I can  Concurrent claims
                          claim a request.        cannot assign the same
                                                  request twice.

  US-012                  As an attendant, I can  Status and actor are
                          mark a vehicle ready.   recorded and customer
                                                  is notified.

  US-013                  As an attendant, I can  Session closes with
                          confirm handoff.        handoff timestamp and
                                                  actor.

  US-014                  As a customer, I can    Provider-confirmed
                          pay digitally.          payment is recorded
                                                  once.

  US-015                  As an attendant, I can  Amount, method,
                          record an offline       employee, and time are
                          payment.                auditable.

  US-016                  As a manager, I can     Results are scoped to
                          view active sessions.   authorized locations.

  US-017                  As a manager, I can     Metrics are calculated
                          view reports.           from sessions and
                                                  payment records.

  US-018                  As a platform admin, I  Privileged actions are
                          can manage tenants.     separately authorized
                                                  and audited.
  -----------------------------------------------------------------------

## 6. Session state model

Operational status: - `CHECKED_IN` - `AWAITING_PARKING` - `PARKED` -
`RETRIEVAL_REQUESTED` - `RETRIEVING` - `READY_FOR_PICKUP` -
`COMPLETED` - `CANCELLED` (manager/authorized exception only)

Payment status: - `NOT_REQUIRED` - `UNPAID` - `PENDING` - `PAID` -
`PARTIALLY_PAID` - `REFUNDED` - `FAILED` - `VOIDED`

Do not combine these into one status field.

## 7. Screen inventory

### Customer mobile app

-   C-01 Welcome / sign-in
-   C-02 Home and active tickets
-   C-03 Digital ticket / QR
-   C-04 Vehicle details
-   C-05 Request retrieval confirmation
-   C-06 Retrieval progress
-   C-07 Payment checkout
-   C-08 Receipt
-   C-09 Ticket history
-   C-10 Profile

### Customer mobile web

-   CW-01 Secure ticket landing
-   CW-02 Ticket details
-   CW-03 Retrieval request
-   CW-04 Retrieval tracking
-   CW-05 Payment checkout
-   CW-06 Receipt

### Attendant mobile app

-   A-01 Login
-   A-02 Location selection
-   A-03 Operations dashboard
-   A-04 Vehicle check-in form
-   A-05 Condition photos
-   A-06 Parking label assignment
-   A-07 Ticket confirmation
-   A-08 Active vehicle search
-   A-09 Vehicle/session details
-   A-10 Retrieval queue
-   A-11 Retrieval task details
-   A-12 Ready for pickup
-   A-13 Payment recording
-   A-14 Handoff confirmation
-   A-15 Activity history

### Company manager web

-   M-01 Login
-   M-02 Dashboard
-   M-03 Company profile
-   M-04 Locations
-   M-05 Location configuration
-   M-06 Employees
-   M-07 Roles and permissions
-   M-08 Active sessions
-   M-09 Retrieval requests
-   M-10 Customers
-   M-11 Pricing rules
-   M-12 Payments
-   M-13 Reports
-   M-14 Parking labels
-   M-15 Location subscriptions
-   M-16 Settings

### Platform administration

-   P-01 Platform dashboard
-   P-02 Tenant directory
-   P-03 Tenant details
-   P-04 Subscription plans
-   P-05 Subscription billing
-   P-06 Usage analytics
-   P-07 Support access
-   P-08 Platform audit log

## 8. Architecture

### Recommended MVP architecture

Use a modular monolith with clear domain boundaries. Avoid microservices
until independent scaling or team ownership justifies them.

**Clients** - Swift/Kotlin for customer and attendant mobile
apps - Next.js for company and platform admin web - Responsive customer
ticket web pages

**Backend** - NestJS / Node.js REST API - PostgreSQL - Prisma ORM (with
explicit SQL migrations for RLS and advanced constraints) - WebSocket or
managed realtime channel for retrieval queues - Object storage
(S3-compatible) for vehicle photos - Payment provider such as Stripe -
SMS provider such as Twilio - Push notifications through APNs/FCM

### Backend modules

1.  Identity and access
2.  Organizations and memberships
3.  Locations and parking labels
4.  Customers and vehicles
5.  Parking sessions
6.  Tickets
7.  Retrieval requests
8.  Pricing and payments
9.  Notifications
10. Reporting
11. Subscriptions
12. Audit and platform administration

### Multi-tenant security

-   Shared PostgreSQL database and shared schema for MVP.
-   `organization_id` on every tenant-owned record.
-   Derive tenant context from authenticated membership on the server.
-   Never trust a client-provided organization ID as authorization.
-   Apply PostgreSQL Row Level Security to tenant-owned tables.
-   Use a separate, tightly controlled platform-admin path.
-   Scope object-storage access to tenant and session.
-   Add automated tests that attempt cross-tenant reads and writes.
-   Ensure background jobs and webhooks resolve tenant context safely.

## 9. Database schema --- logical model

All primary keys should be UUIDs. Use `timestamptz` for timestamps.
Store currency amounts as integer minor units (for example, cents) and
include ISO currency code.

  -----------------------------------------------------------------------------
  Table                         Important fields        Notes
  ----------------------------- ----------------------- -----------------------
  organizations                 id, name, slug, status, Tenant root
                                created_at              

  locations                     id, organization_id,    Tenant location
                                name, address,          
                                timezone, status        

  users                         id, email, phone,       Global identity
                                auth_subject, status    

  organization_members          id, organization_id,    User membership
                                user_id, role_id,       
                                status                  

  location_members              id, organization_id,    Location assignment
                                location_id, user_id,   
                                role_id                 

  roles                         id, organization_id,    Tenant roles; system
                                name, permissions_json  roles may be seeded

  customers                     id, organization_id,    Customer profile
                                name, phone, email      

  vehicles                      id, organization_id,    Vehicle identity
                                customer_id, plate,     
                                plate_region, make,     
                                model, color            

  parking_sessions              id, organization_id,    Core transaction
                                location_id,            
                                customer_id,            
                                vehicle_id, ticket_id,  
                                operational_status,     
                                payment_status,         
                                checked_in_at,          
                                completed_at            

  tickets                       id, organization_id,    Store token hash, not
                                session_id,             raw token
                                public_number,          
                                token_hash, expires_at, 
                                revoked_at              

  parking_labels                id, organization_id,    Configurable
                                location_id, label,     spaces/areas
                                description, active     

  session_parking_assignments   id, organization_id,    Assignment history
                                session_id,             
                                parking_label_id,       
                                assigned_by,            
                                assigned_at,            
                                released_at             

  vehicle_photos                id, organization_id,    Condition evidence
                                session_id,             
                                storage_key,            
                                photo_type, notes,      
                                captured_at,            
                                captured_by             

  retrieval_requests            id, organization_id,    Retrieval lifecycle
                                session_id, status,     
                                requested_at,           
                                accepted_by,            
                                accepted_at, ready_at,  
                                completed_at            

  session_status_history        id, organization_id,    Append-only history
                                session_id,             
                                from_status, to_status, 
                                actor_user_id,          
                                occurred_at,            
                                metadata_json           

  pricing_rules                 id, organization_id,    Version or snapshot
                                location_id, name,      rules for sessions
                                rule_type,              
                                amount_minor, currency, 
                                parameters_json, active 

  payments                      id, organization_id,    Payment ledger
                                location_id,            
                                session_id,             
                                amount_minor, currency, 
                                method, status,         
                                provider_reference,     
                                recorded_by, created_at 

  receipts                      id, organization_id,    Receipt record
                                payment_id,             
                                receipt_number,         
                                issued_at, storage_key  

  notifications                 id, organization_id,    Delivery tracking
                                recipient, channel,     
                                template, status,       
                                provider_reference,     
                                sent_at                 

  audit_logs                    id, organization_id,    Security/operational
                                actor_user_id, action,  audit
                                resource_type,          
                                resource_id,            
                                occurred_at,            
                                metadata_json           

  subscription_plans            id, name,               SaaS plans
                                monthly_price_minor,    
                                currency,               
                                location_limit,         
                                features_json           

  subscriptions                 id, organization_id,    Per-location
                                location_id, plan_id,   subscription
                                status,                 
                                billing_provider_id,    
                                current_period_start,   
                                current_period_end      

  webhook_events                id, provider,           Idempotent webhook
                                provider_event_id,      handling
                                processed_at, status    
  -----------------------------------------------------------------------------

### Important constraints and indexes

-   Unique organization slug.
-   Unique membership per `(organization_id, user_id)`.
-   Unique location membership per `(location_id, user_id)`.
-   Unique ticket public number within organization or globally.
-   Unique token hash.
-   Unique provider event ID per provider.
-   Index sessions by
    `(organization_id, location_id, operational_status, checked_in_at)`.
-   Index vehicles by `(organization_id, normalized_plate)`.
-   Index retrieval requests by
    `(organization_id, location_id, status, requested_at)`.
-   Enforce one active parking assignment per label.
-   Enforce one active session per vehicle per location if this is the
    chosen operating rule.
-   Use foreign keys that preserve organization consistency; consider
    composite foreign keys including organization_id.
-   Keep status history append-only.

## 10. REST API specification

Base path: `/api/v1`

All authenticated endpoints require authorization. Tenant and location
scope are resolved from the authenticated principal and membership.

  ---------------------------------------------------------------------------------------------
  Method                  Endpoint                                      Purpose
  ----------------------- --------------------------------------------- -----------------------
  POST                    `/auth/login`                                 Authenticate

  GET                     `/me`                                         Current user and
                                                                        memberships

  POST                    `/organizations`                              Provision organization

  GET                     `/organizations/current`                      Current organization

  POST                    `/locations`                                  Create location

  GET                     `/locations`                                  List authorized
                                                                        locations

  PATCH                   `/locations/:locationId`                      Update location

  POST                    `/locations/:locationId/members`              Assign employee

  POST                    `/parking-labels`                             Create parking label

  GET                     `/locations/:locationId/parking-labels`       List labels

  POST                    `/sessions`                                   Check in vehicle

  GET                     `/sessions`                                   Search/list sessions

  GET                     `/sessions/:sessionId`                        Session detail

  POST                    `/sessions/:sessionId/photos`                 Attach photo
                                                                        metadata/upload

  POST                    `/sessions/:sessionId/parking-assignment`     Assign parking label

  PATCH                   `/sessions/:sessionId/status`                 Transition operational
                                                                        status

  POST                    `/sessions/:sessionId/ticket`                 Issue/reissue ticket

  GET                     `/public/tickets/:token`                      Public ticket view

  POST                    `/public/tickets/:token/retrieval-requests`   Customer retrieval
                                                                        request

  GET                     `/retrieval-requests`                         Attendant queue

  POST                    `/retrieval-requests/:requestId/accept`       Atomically accept
                                                                        request

  POST                    `/retrieval-requests/:requestId/ready`        Mark ready

  POST                    `/sessions/:sessionId/handoff`                Confirm handoff

  POST                    `/sessions/:sessionId/payment-intents`        Start digital payment

  POST                    `/payments/offline`                           Record attendant
                                                                        payment

  POST                    `/webhooks/payments/:provider`                Payment provider
                                                                        webhook

  GET                     `/reports/summary`                            Manager dashboard
                                                                        metrics

  GET                     `/subscriptions`                              List location
                                                                        subscriptions

  POST                    `/subscriptions`                              Create subscription
  ---------------------------------------------------------------------------------------------

### Example --- vehicle check-in

`POST /api/v1/sessions`

``` json
{
  "locationId": "uuid",
  "customer": {
    "name": "Alex Customer",
    "phone": "+15555550123"
  },
  "vehicle": {
    "plate": "ABC123",
    "plateRegion": "NH",
    "make": "Honda",
    "model": "Accord",
    "color": "Black"
  },
  "notes": "Customer reports existing scratch on rear bumper"
}
```

The backend derives `organization_id` and `checked_in_by` from the
authenticated user. The client must not choose an arbitrary tenant.

### Example response

``` json
{
  "sessionId": "uuid",
  "ticketNumber": "V-2026-001234",
  "operationalStatus": "CHECKED_IN",
  "paymentStatus": "UNPAID",
  "createdAt": "2026-11-14T20:00:00Z"
}
```

### Example --- retrieval request acceptance

`POST /api/v1/retrieval-requests/:requestId/accept`

The operation must use a database transaction or conditional update so
only one attendant succeeds. A competing request receives
`409 CONFLICT`.

### API conventions

-   Use ISO 8601 timestamps in UTC.
-   Return consistent validation and authorization errors.
-   Use pagination for list endpoints.
-   Support idempotency keys for payment creation and other
    retry-sensitive operations.
-   Verify payment webhook signatures.
-   Deduplicate provider webhook events.
-   Rate-limit public ticket endpoints.
-   Do not expose customer phone/email or internal notes on public
    ticket pages.

## 11. UI design system and wireframe requirements

**Visual direction:** Premium, calm, operationally clear.

-   Typography: Inter or system sans-serif.
-   Primary: deep navy.
-   Accent: teal.
-   Background: light neutral.
-   Cards: restrained radius and subtle borders.
-   Buttons: large mobile touch targets.
-   Status labels: text plus color/icon, never color alone.
-   Accessibility: readable contrast, scalable text, screen-reader
    labels.

### Attendant dashboard

-   Location selector
-   Active vehicle count
-   Awaiting-parking queue
-   Retrieval request queue
-   Primary "Check In Vehicle" action
-   Search by ticket or plate

### Check-in screen

-   Customer name and phone
-   Vehicle plate, region, make, model, color
-   Condition photo capture
-   Damage notes
-   Save and issue ticket

### Customer ticket

-   Valet company and location
-   Ticket number and QR
-   Vehicle summary
-   Current operational status
-   Request vehicle button
-   Payment status and amount when applicable

### Manager dashboard

-   Active sessions
-   Retrieval requests
-   Completed sessions today
-   Collected payments
-   Average retrieval time
-   Location filter and date range

## 12. Non-functional requirements and release gates

### Security

-   TLS for all network traffic.
-   Secure credential handling and session revocation.
-   RBAC and location-level authorization.
-   Database RLS and cross-tenant penetration tests.
-   Signed, expiring upload URLs.
-   Short-lived/revocable public ticket tokens.
-   Audit trail for privileged and financial actions.

### Reliability

-   Payment webhooks are idempotent.
-   Retrieval acceptance is concurrency-safe.
-   Ticket creation succeeds independently of SMS delivery.
-   Notification failures are retried and visible.
-   Database backups and restore tests are in place.

### Performance targets

-   Common API reads: p95 under 500 ms under pilot load.
-   Retrieval event delivery: target under 5 seconds under normal
    connectivity.
-   Ticket generation: target under 3 seconds.
-   Availability target: 99.9%, to be validated against hosting and
    operational budget.

### Pilot release gates

-   Tenant isolation tests pass.
-   Check-in to ticket workflow passes end-to-end.
-   Retrieval request and handoff workflow passes end-to-end.
-   Duplicate retrieval acceptance is prevented.
-   Payment success, failure, retry, and duplicate webhook scenarios
    pass.
-   Attendant can recover from SMS failure.
-   Manager can see accurate active sessions.
-   Operational audit history is complete.

## 13. Suggested implementation sequence

1.  Foundation: identity, tenant model, memberships, locations,
    authorization.
2.  Operations: vehicle/customer records, sessions, photos, parking
    labels.
3.  Ticketing: ticket issuance, secure customer web access, QR.
4.  Retrieval: request queue, assignment, notifications, handoff.
5.  Payments: pricing, provider integration, offline payment, receipts.
6.  Management: dashboard, reports, per-location subscriptions.
7.  Pilot hardening: security, accessibility, monitoring, backups,
    support.

A small experienced team might target roughly 10--14 weeks for a focused
pilot, depending on payment, notification, design, and compliance
requirements. This is an estimate, not a commitment.

## 14. Open decisions for implementation

These items should be confirmed before the relevant module is built: -
Whether check-in requires a parking label immediately or allows an
awaiting-parking state. - Whether a customer can request retrieval while
payment is unpaid. - Which payment methods are permitted for
attendant-recorded payments. - Whether each location has its own pricing
or inherits company defaults. - Whether a vehicle may have concurrent
sessions at different locations within one company. - Whether attendants
can edit check-in details after ticket issuance, and how edits are
audited. - Which identity checks are required at handoff.

------------------------------------------------------------------------
