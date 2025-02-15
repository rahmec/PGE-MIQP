

# Program
prog = MixedIntegerLinearProgram()

# Constants
m = 7
n = 7
q = 3
A = random_matrix(GF(q),m,n)
list_A = [[Integer(A[i][j]) for j in range(n)] for i in range(m)]
sig = 2

# Variables
x = prog.new_variable(integer=True, nonnegative=True)
p = prog.new_variable(integer=True, nonnegative=True)
k = prog.new_variable(integer=True, nonnegative=True)
r = prog.new_variable(integer=True, nonnegative=True) # remainder

# Constraints

r.set_max(q-1)
x.set_max(q-1)
p.set_max(q-1)

# x submatrix diagonal = 1
for i in range(sig+1):
        prog.add_constraint(x[m-i,n-i] == 1)

# x last sigma columns all zero except in diagonal
for i in range(1,m+1):
    for j in range(n-sig,n+1):
        if i in range(m-sig,m+1) and i == j:
            continue
        else:
            prog.add_constraint(x[i,j] == 0)

# every row must be linear combination of itself
for i in range(1,m+1):
        prog.add_constraint(p[i,i] >= 1)

# Check if linear combination is odd (1 in GF(2)) or even(0 in GF(2))
for i in range(1,m+1):
    for j in range(1,n+1):
        prog.add_constraint(prog.sum(list_A[k-1][j-1]*p[i,k] for k in range(1,m+1)) == q*k[i,j] + r[i,j])

# x linear combination of rows
for i in range(1,m+1):
    for j in range(1,n+1):
        prog.add_constraint(x[i,j] == r[i,j]) # Attento a somma


# Objective function
prog.set_objective(0)

try:
    prog.solve(log=2)
    X = Matrix(GF(q),m,n)
    P = Matrix(GF(q),m,n)

    for i in range(m):
        for j in range(n):
            X[i,j]=prog.get_values(x)[i+1,j+1]

    for i in range(m):
        for j in range(m):
            P[i,j]=prog.get_values(p)[i+1,j+1]

    print("=====ORIGINAL MATRIX=====")
    print()
    print(A)
    print()
    print("=====POST-PGE MATRIX=====")
    print()
    print(P*A)
except:
    print("Left {sig} columns rank too low")

