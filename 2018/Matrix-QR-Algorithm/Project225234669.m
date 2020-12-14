function EIG = Project225234669(A, tau)

tic
A0 = A;
n = size(A,1);
if ~isequal(A,transpose(A))
    EIG = 'error';
    return
end

% Return error message if matrix is not symmetric

k = 1;
H = eye(n);
while k < n-1
    i = k+1:n;
    target = A(k+1,k);
    alpha = -sign(target)*sqrt(sum(A(i,k).^2));
    r = sqrt(.5*alpha^2 - .5*alpha*target);
    w = zeros(n,1);
    w(k+1) = (A(k+1,k)-alpha)/(2*r);
    for j = k+2:n
        w(j) = A(j,k)/(2*r);
    end
    P = eye(n) - 2*w*transpose(w);
    H = H*P;
    A = P*A*P;
    k = k+1;
end

EIG.H = H;
EIG.T = A;

% EIG.H is the product of Householder transformations P1*P2*...*P(n-2)
% EIG.T is the tridiagonal matrix derived from the transformations

T0 = A;
V1 = 0;
V2 = 0;
m = 0;
% m denotes the least number of iterations needed to make null() work
while size(V1,2)~=n || size(V2,2)~=n
    Q = eye(n);
    R = A;
    k = 1;
    while k < n
        x = A(k,k);
        b = A(k+1,k);
        s = b/sqrt(x^2+b^2);
        c = x/sqrt(x^2+b^2);
        P = eye(n);
        P(k,k) = c;
        P(k+1,k+1) = c;
        P(k+1,k) = -s;
        P(k,k+1) = s;
        A = P*A;
        Q = Q*transpose(P);
        R = P*R;
        k = k+1;
    end
    A = R*Q;
    V1 = null(T0 - A(1,1)*eye(n));
    for i = 2:n
        V1 = [V1, null(T0 - A(i,i)*eye(n))]; %#ok<AGROW>
    end
    if size(V1,2) == n
        EIG.QT = V1;
    else
        EIG.QT = 'error';
    end
    V2 = null(A0 - A(1,1)*eye(n));
    for i = 2:n
        V2 = [V2, null(A0 - A(i,i)*eye(n))]; %#ok<AGROW>
    end
    if size(V2,2) == n
        EIG.Q = V2;
    else
        EIG.Q = 'error';
    end
    % EIG.QT and EIG.Q are the eigenvectors of T and A, respectively
    % Return error message if not all eigenvectors are output
    m = m+1;
end

for i = 1:n
    D(i) = A(i,i); %#ok<AGROW>
end
EIG.D = transpose(D);

% EIG.D is the column vector of eigenvalues
    
if size(V2,2) == n
    n1 = A0*EIG.Q - EIG.Q*diag(EIG.D);
    EIG.res_norm = norm(n1,2);
    n2 = transpose(EIG.Q)*EIG.Q - eye(n);
    EIG.orth_norm = norm(n2,2);
else
    EIG.res_norm = 'error';
    EIG.orth_norm = 'error';
end

% EIG.res_norm and EIG.orth_norm are 2-norms that are theoretically 0

elapsedTime = toc;
EIG.time = elapsedTime;

eig(A0);
[V, D] = eig(A0); %#ok<ASGLU>

elapsedTime2 = toc;
EIG.matlab = elapsedTime2 - elapsedTime;

EIG.n_iter = m;
if EIG.res_norm > tau || EIG.orth_norm > tau
    EIG.error = 'tau too small';
end

end