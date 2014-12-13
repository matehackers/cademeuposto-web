#!/usr/bin/perl -w

use strict;
use warnings;

use CGI qw(:standard);
use DBI;

sub croak {
	die "$0: @_: $!\n"
}

my $arquivo_banco = './db/areas-de-atuacao-aps.db';

my $dbh = DBI->connect(
	"dbi:SQLite:dbname=$arquivo_banco",
	"",
	"",
	{ RaiseError => 1 },
) or croak $DBI::errstr;

my $rua = param('rua') || "Nome da rua";
my $numero = param('numero') || "Número da casa";
my $limit = param('de') || '0';

my ${select_stmt} = "SELECT * FROM postos WHERE NOME_DA_RUA LIKE \"${rua}\" ORDER BY INICIAL COLLATE NOCASE;";
my ${sth} = ${dbh}->prepare(${select_stmt}) or croak $DBI::errstr;
${sth}->execute() or croak $DBI::errstr;

my $posto = ${sth}->fetchrow_array;

print <<EOF;
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="../../favicon.ico">

<title>Cadê meu posto de saúde?</title>

<!-- Bootstrap core CSS -->
<link href="./bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="./bootstrap/css/jumbotron.css" rel="stylesheet">
<link href="./bootstrap/css/grid.css" rel="stylesheet">

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->

</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#">Cad&ecirc; meu posto de sa&uacute;de?</a>
			<a class="navbar-brand" href="https://github.com/matehackers/cademeuposto-perl">C&oacute;digo fonte</a>
		</div>
	</div>
</nav>

<div class="jumbotron">
	<div class="container">
		<center>
		<img src="./favicon.ico" />
		<h1>Busca de unidades de sa&uacute;de de refer&ecirc;ncia em Porto Alegre</h1>
		</center>
		<p>Entre com o nome e o número da casa para encontrar a unidade de sa&uacute;de de refer&ecirc;ncia.</p>
	</div>
</div> <!-- /jumbotron -->

<!-- formulario -->
	<div class="container">
		<center>
		<form class="navbar-form" role="form">
			<div class="form-group">
				<input type="text" placeholder="Nome da rua ou parte" class="form-control">
			</div>
			<div class="form-group">
				<input type="text" placeholder="Número" class="form-control">
			</div>
			<button type="submit" class="btn btn-success">Buscar</button>
		</form>

		<form action='./index.pl'>
			<div>Nome da rua: <input name='rua' size='20'>${rua}</div>
			<div><input type='submit'></div>
		</form>

		</center>
	</div> <!-- /container -->
<!-- /formulario -->
EOF

my @{resultados};

if (${sth}->fetchrow_array) {
print <<EOF;
<!-- resultado -->
<div class="container">
	<h2>Quem mora na(o)...</h2>
EOF

	while ( @{resultados} = ${sth}->fetchrow_array ) {
		print <<EOF;
	<div class="row">
		<div class="col-xs-6 col-sm-4">${resultados[1]} ${resultados[2]} ${resultados[3]}</div>
		<div class="col-xs-6 col-sm-4">do número ${resultados[4]} até o ${resultados[5]}, </div>
		<div class="col-xs-6 col-sm-4">deve ir na(o) ${resultados[6]}.</div>
	</div>
<!-- /resultado -->
EOF

	}
} else {
	print <<EOF;
<div class="container">
	Nenhum resultado.
</div>
EOF
}

print <<EOF;
	<hr>

</div> <!-- /container -->


<div class="container">
	<div class="row">
		<div class="col-md-4">
			<h2>T&iacute;tulo</h2>
			<p>Mussum ipsum cacilds, vidis litro abertis. Consetis adipiscings elitis. Pra lá , depois divoltis porris, paradis. Paisis, filhis, espiritis santis. Mé faiz elementum girarzis, nisi eros vermeio, in elementis mé pra quem é amistosis quis leo. Manduma pindureta quium dia nois paga. Sapien in monti palavris qui num significa nadis i pareci latim. Interessantiss quisso pudia ce receita de bolis, mais bolis eu num gostis.</p>
			<p><a class="btn btn-default" href="#" role="button">Bot&atilde;o &raquo;</a></p>
		</div>
		<div class="col-md-4">
			<h2>T&iacute;tulo</h2>
			<p>Suco de cevadiss, é um leite divinis, qui tem lupuliz, matis, aguis e fermentis. Interagi no mé, cursus quis, vehicula ac nisi. Aenean vel dui dui. Nullam leo erat, aliquet quis tempus a, posuere ut mi. Ut scelerisque neque et turpis posuere pulvinar pellentesque nibh ullamcorper. Pharetra in mattis molestie, volutpat elementum justo. Aenean ut ante turpis. Pellentesque laoreet mé vel lectus scelerisque interdum cursus velit auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ac mauris lectus, non scelerisque augue. Aenean justo massa.</p>
			<p><a class="btn btn-default" href="#" role="button">Bot&atilde;o &raquo;</a></p>
	 </div>
		<div class="col-md-4">
			<h2>T&iacute;tulo</h2>
			<p>Casamentiss faiz malandris se pirulitá, Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer Ispecialista im mé intende tudis nuam golada, vinho, uiski, carirí, rum da jamaikis, só num pode ser mijis. Adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.</p>
			<p><a class="btn btn-default" href="#" role="button">Bot&atilde;o &raquo;</a></p>
		</div>
</div> <!-- /container -->

<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>

	<hr>

	<footer>
		<p>&copy; Company 2014</p>
	</footer>
</div> <!-- /container -->


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="../../dist/js/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
</body>
</html>
EOF

undef(${dbh});

