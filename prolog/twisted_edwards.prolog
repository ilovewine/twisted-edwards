% E: ax^2 + y^2 = 1 + dx^2y^2
% ad(a-d) neq 0

:- module(twisted_edwards, [is_point_on_curve/2, is_prime/1]).

is_prime(Number) :- \+ is_divisible(Number).

is_divisible(Number) :- is_divisible(Number, 2).
is_divisible(Number, X) :- Number mod X =:= 0, !.
is_divisible(Number, X) :- X < ceiling(sqrt(Number)), N is X+1, is_divisible(Number, N).

get_point_coordinates(point(CoordX, CoordY), [CoordX, CoordY]).
get_curve_coefficients(curve(CoefficientA, CoefficientD, Modulo), [CoefficientA, CoefficientD, Modulo]).

is_curve(curve(CoefficientA, CoefficientD, Modulo)) :-
	CoefficientA =\= 0,
	CoefficientD =\= 0,
	CoefficientA =\= CoefficientD,
	is_prime(Modulo),
	CoefficientA < Modulo,
	CoefficientD < Modulo.

is_point_on_curve(Point, Curve) :-
	get_point_coordinates(Point, [CoordinateX, CoordinateY]),
	is_curve(Curve),
	get_curve_coefficients(Curve, [CoefficientA, CoefficientD, Modulo]),
	CoordXPow2 is powm(CoordinateX, 2, Modulo), CoordYPow2 is powm(CoordinateY, 2, Modulo),
	(CoefficientA * CoordXPow2 + CoordYPow2) mod Modulo =:= (1 + CoefficientD * CoordXPow2 * CoordYPow2) mod Modulo.
