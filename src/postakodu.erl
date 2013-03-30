-module (postakodu).
-export([start/0, handle/3]).

-include_lib("axiom/include/response.hrl").

-record(location, {name, slug}).

start() ->
	postakodu_templates:compile_all(),
	init_couchdb(),
    	axiom:start(?MODULE).

% index
handle('GET', [], _Request) ->
	Docs = postakodu_db:load_by_parent(<<"0">>),
	Locations = collect_locations(Docs),
	axiom:dtl(home, [{breadcrumb, <<"Türkiye">>}, {locations, Locations}]);

handle('GET', [<<"refresh">>], _Request) ->
	postakodu_templates:compile_all(),
	<<"ok">>;

handle('GET', [<<"hakkimizda">>], _Request) ->
	axiom:dtl(about, []);

handle('GET', [Slug], Request) ->
	Doc = postakodu_db:load_by_slug(Slug),
	%Json = jiffy:encode(Doc),
        % #response{headers = [{'Content-Type', [ <<"application/json">>] }], body = Json}.
	process_slug_result(Doc, Slug, Request).

process_slug_result({error,empty}, Slug, _Request) ->
        %#response{status = 301 ,headers = [{'Location', [ <<"http://www.postakodubul.com/">>] }]}
        response_404(Slug);

process_slug_result({ok, Result}, _Slug, _Request) ->
	Doc = couchbeam_doc:get_value(<<"value">>, Result),

	Id = couchbeam_doc:get_value(<<"_id">>, Doc),
	Name = couchbeam_doc:get_value(<<"name">>, Doc),
	Pcode = couchbeam_doc:get_value(<<"pcode">>, Doc),
	Breadcrumb = couchbeam_doc:get_value(<<"breadcrumb">>, Doc),
	
	Docs = postakodu_db:load_by_parent(Id),
	Locations = collect_locations(Docs),
	
	axiom:dtl(home, [{pcode, Pcode}, {name, Name} ,
		{breadcrumb, Breadcrumb}, {locations, Locations}]).

collect_locations(Docs) ->
	[ couchbeam_doc:get_value(<<"value">>, Doc) || Doc <- Docs ].

response_404(Url) ->
	Body = axiom:dtl(axiom_error_404, [{path, io_lib:format("~p", [Url])}]),
	#response{status = 404 ,body = Body}.

init_couchdb() ->
	application:start(sasl),
	application:start(ibrowse),
	application:start(couchbeam).
