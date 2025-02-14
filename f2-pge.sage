

# Program
prog = MixedIntegerLinearProgram()

# Variables
x = prog.new_variable(binary=True)
p = prog.new_variable(binary=True)
b = prog.new_variable(binary=True)
k = prog.new_variable(integer=True)
d = prog.new_variable(integer=True)

# Constants
m = 10
n = 10
A = random_matrix(GF(2),m,n)
sig = 4

# Constraints

# x submatrix diagonal = 1
for i in range(sig+1):
        prog.add_constraint(x[m-i,n-i] == 1)

# x last sigma columns have only one 1
for j in range(n-sig,n+1):
        prog.add_constraint(prog.sum(x[i,j] for i in range(1,m+1)) == 1)

# every row must be linear combination of itself
for i in range(1,m+1):
        prog.add_constraint(p[i,i] == 1)

# Check if linear combination is odd (1 in GF(2)) or even(0 in GF(2))
for i in range(1,m+1):
    for j in range(1,n+1):
        prog.add_constraint(prog.sum(A[k-1][j-1]*p[i,k] for k in range(1,m+1)) == 2*k[i,j] + b[i,j])

# x linear combination of rows
for i in range(1,m+1):
    for j in range(1,n+1):
        prog.add_constraint(x[i,j] == b[i,j]) # Attento a somma


# Objective function
prog.set_objective(0)

try:
    prog.solve()
    X = Matrix(GF(2),m,n)
    P = Matrix(GF(2),m,n)

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

