---- MODULE ResourcePool ----
EXTENDS Naturals, FiniteSets, TLC

CONSTANTS Resources, Clients, MaxHeld
ASSUME MaxHeld \in Nat /\ MaxHeld >= 1
ASSUME Resources # {}
ASSUME Clients # {}

VARIABLES held, pending

vars == <<held, pending>>

TypeOK ==
  /\ held \in [Clients -> SUBSET Resources]
  /\ pending \in [Clients -> SUBSET Resources]
  /\ \A c \in Clients: held[c] \cap pending[c] = {}

Allocated == UNION {held[c] : c \in Clients}

InvCapacity == Cardinality(Allocated) <= MaxHeld

InvExclusive ==
  \A c1, c2 \in Clients:
    c1 # c2 => held[c1] \cap held[c2] = {}

Init ==
  /\ held = [c \in Clients |-> {}]
  /\ pending = [c \in Clients |-> {}]

Request(c, r) ==
  /\ r \notin held[c]
  /\ r \notin pending[c]
  /\ pending' = [pending EXCEPT ![c] = @ \union {r}]
  /\ UNCHANGED held

Acquire(c, r) ==
  /\ r \in pending[c]
  /\ r \notin Allocated
  /\ Cardinality(Allocated) < MaxHeld
  /\ held' = [held EXCEPT ![c] = @ \union {r}]
  /\ pending' = [pending EXCEPT ![c] = @ \ {r}]

Release(c, r) ==
  /\ r \in held[c]
  /\ held' = [held EXCEPT ![c] = @ \ {r}]
  /\ UNCHANGED pending

Withdraw(c, r) ==
  /\ r \in pending[c]
  /\ pending' = [pending EXCEPT ![c] = @ \ {r}]
  /\ UNCHANGED held

Next ==
  \E c \in Clients:
    \E r \in Resources:
      \/ Request(c, r)
      \/ Acquire(c, r)
      \/ Release(c, r)
      \/ Withdraw(c, r)

Spec == Init /\ [][Next]_vars

====
