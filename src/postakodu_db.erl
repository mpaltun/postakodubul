-module (postakodu_db).
-export ([load_by_parent/1, load_by_slug/1]).

load_by_slug(Slug) ->
	couchbeam_view:first(open_db(),
		{<<"location">>, <<"bySlug">>},
		[{key, Slug}, {limit, 1}]).

load_by_parent(Parent) ->
	{ok, Response} = couchbeam_view:fetch(open_db(),
                {<<"location">>, <<"byParent">>},
                [
			{start_key, [Parent]},
			{end_key, [<<Parent/binary, "0">>]}
		]
	),
        Response.

get_server() ->
	Host = "localhost",
	Port = 5984,
	Prefix = "",
	Options = [],
	couchbeam:server_connection(Host, Port, Prefix, Options).

open_db() ->
	Server = get_server(),
	{ok, Db} = couchbeam:open_db(Server, "postakodu", []),
	Db.
