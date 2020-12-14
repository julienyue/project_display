# Case 1

param n;
param m;
set J := {1..n};
set I := {1..m};
set Q := {1..sqrt(n)};

param C {J} >= 0;
param A {I,J} >= 0;
param B {I} >= 0;
param Ord {J} >= 0;
param Min {J} >= 0;
param Max {J} >= 0;
var X {J} >= 0 integer;

maximize prof: sum {j in J} C[j] * X[j];

s.t. Con1 {i in I}:
    sum {j in J} A[i,j] * X[j] <= B[i];
s.t. Con2 {j in J}:
    -X[j] <= -Ord[j];
s.t. Con3 {q in Q}:
    -(X[3*q-2] + X[3*q-1] + X[3*q]) <= -(Min[q]/100 * sum {j in J} X[j]);
s.t. Con4 {q in Q}:
    -(X[q] + X[3+q] + X[6+q]) <= -(Min[3+q]/100 * sum {j in J} X[j]);
s.t. Con5 {q in Q}:
    X[3*q-2] + X[3*q-1] + X[3*q] <= Max[q]/100 * sum {j in J} X[j];
s.t. Con6 {q in Q}:
    X[q] + X[3+q] + X[6+q] <= Max[3+q]/100 * sum {j in J} X[j];

# decision variables
# X[1]: number of economy student produced
# X[2]: number of economy standard produced
# X[3]: number of economy executive produced
# X[4]: number of basic student produced
# X[5]: number of basic standard produced
# X[6]: number of basic executive produced
# X[7]: number of hand-crafted student produced
# X[8]: number of hand-crafted standard produced
# X[9]: number of hand-crafted executive produced

# objective is to maximize the total profit
# prof: total production profit

# constraints
# B[1]: labor in man*minute
# B[2]: aluminum in square foot
# B[3]: particle board in square foot
# B[4]: pine sheets in square foot
# B[5]: production line 1 in minute
# B[6]: production line 2 in minute
# B[7]: production line 3 in minute