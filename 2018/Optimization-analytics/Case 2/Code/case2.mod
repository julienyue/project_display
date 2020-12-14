# Case 2
set P := {1..5}; # Five choices of plants
set C := {1..3}; # Three lines of cars

param pm{i in C, j in P}; # Profit margin
param fc{j in P}; # Fixed cost
param cp{j in P}; # Production capacity
param dm{i in C}; # Demand
param dv{i in C, k in C}; # Diversion table

# Decision Variables
var b1 binary; # b1 = 1 if retooled and b1 = 0 if not
var b2 binary; # b2 = 1 if retooled and b2 = 0 if not
# b1 (binary) denotes whether the Lyra plant should be retooled.
# b2 (binary) denotes whether the Libra plant should be retooled.
var y{i in C, j in P} >= 0 integer; 
# y[i,j] is the number of car i to be produced by plant j.
var z{i in C} >= 0 integer;  
# z[i] is the unsatisfied demand for car i that GMC plans to harness.
var tfc >= 0 ; # tfc denotes total fixed cost.

# Objective Function
maximize profit: 
sum {i in C, j in P} (pm[i,j] * y[i,j]) - tfc;
# Important Note: In our data file, both the profit margin and the fixed cost are in $1,000.
# Hence, there is no need to convert unit.

# Constraints
# I. Fixed Cost
s.t. t_f_c: tfc = fc[1] * (1-b1) + fc[2] * (1-b2) + fc[3] + fc[4] * b1 + fc[5] * b2;
# Total fixed cost depends on the retooling plan.

# II. Plants
s.t. p1: y[1,1] <= cp[1] * (1 - b1);             # Production constraint for (Orig) Lyra
s.t. p2: y[2,2] <= cp[2] * (1 - b2);             # Production constraint for (Orig) Libra
s.t. p3: y[3,3] <= cp[3];                        # Production constraint for (Orig) Hydra
s.t. p4: y[1,4] + y[2,4] <= cp[4] * b1;          # Production constraint for New Lyra
s.t. p5: y[1,5] + y[2,5] + y[3,5] <= cp[5] * b2; # Production constraint for New Libra

# III. Direct unsatisfied demand
s.t. d1: z[1] <= dm[1] - (y[1,1] + y[1,4] + y[1,5]);                          # Excess demand for Lyra to be harnessed.
s.t. d2: z[2] <= dm[2] - (y[2,2] + y[2,4] + y[2,5]) + dv[1,2] * z[1];         # Excess demand for Libra to be harnessed.
s.t. d3: z[3] <= dm[3] - (y[3,3] + y[3,5]) + dv[1,3] * z[1] + dv[2,3] * z[2]; # Excess demand for Hydra to be harnessed.
# Note: z[i] does not need to be equal to the right hand size, "<=" suffices.
# Reason: the salesperson does not need to release his or her full potential of persuasion.

# Conclusions:
# 1. GMC needs to retool the Lyra plant, but not the Libra plant.
# 2. The retooled Lyra plant produces 1,257,150 Lyras and 342,850 Libras (full capacity).
  # Unsatisfied demand for Lyra: 142,850
  # Diversion to Libra: 142,850 * 30% = 42,855
  # Diversion to Hydra: 142,850 * 5% = 7,142.5
  # Lyra demand equilibrium: 1,400,000 = 1,257,150 + 142,850
# 3. The original Libra plant produces 800,000 Libras (full capacity).
  # Unsatisfied demand for Libra: 5
  # Diversion to Hydra: 5 * 10% = 0.5
  # Libra demand equilibrium: 1,100,000 + 42,855 = 800,000 + 342,850 + 5
# 4. The original Hydra plant produces 807,143 Hydras (all Hydra demand satisfied).
  # Hydra demand equilibrium: 800,000 + 7,142.5 + 0.5 = 807,143
# 5. Total fixed cost is 8,000,000 thousand dollars = 8 billion dollars.
# 6. Total profit is 2,607,140 thousand dollars = 2.60714 billion dollars.