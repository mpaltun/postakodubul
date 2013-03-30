-module (postakodu_templates).
-export ([compile_all/0]).

compile_all() ->
	erlydtl:compile('deps/axiom/templates/axiom_error_404.dtl', axiom_error_404_dtl),
	erlydtl:compile('deps/axiom/templates/axiom_error_500.dtl', axiom_error_500_dtl),
	erlydtl:compile('templates/home.dtl', home_dtl),
	erlydtl:compile('templates/about.dtl', about_dtl).