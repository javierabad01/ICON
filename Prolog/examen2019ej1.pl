mueve(q0, a, [z], [z], q0, [a,z], [z]).
mueve(q0, a, [a|H], [z], q0, [a|[a|H]], [z]).
mueve(q0, b, [a|H], [z], q1, H, [b,z]).
mueve(q1, b, [a|H], [b|L], q1, H, [b|[b|L]]).
mueve(q1, c, [z], [b|L], q2, [z], L).
mueve(q2, c, [z], [b|L], q2, [z], L).

transita(q2,[], [z],[z], qf, [z],[z]):-!.
transita(Qi, [X|Y], R, S, Qf, U, V):- X\=[], mueve(Qi, X, R, S, QQ, UU, VV), transita(QQ, Y, UU, VV, Qf, U, V).

acepta(X,Resultado):- transita(q0,X,[z], [z],Q, M, N), M=[z], N=[z], Q=qf, Resultado is 1, !.