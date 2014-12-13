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
#my $numero = param('numero') || "Número da casa";

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
<link href="./estilos.css" rel="stylesheet">

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
			<a class="navbar-brand" href="#">Cad&ecirc; meu posto de sa&uacute;de?</a>
		</div>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="nav navbar-nav">
				<li><a href="http://matehackers.org"><img src="http://matehackers.org/lib/exe/fetch.php/logo.png" height="32px" /></a></li>
				<li><a href="http://datapoa.com.br"><img src="http://datapoa.com.br/img/logo.png" height="32px" /></a></li>
				<li><a href="https://github.com/matehackers/cademeuposto"><img src="./assets/GitHub-Mark-32px.png" /></a></li>
			</ul>
		</div><!--/.nav-collapse -->
	</div>
	</div>
</nav>

<div class="jumbotron">
	<div class="container">
		<center>
		<img src="./assets/pictogram-din-e003-first_aid.png" />
		<h1>Busca unidades de sa&uacute;de de refer&ecirc;ncia em Porto Alegre</h1>
		<p>Entre com o nome <b>completo</b> da rua para encontrar a unidade de sa&uacute;de de refer&ecirc;ncia (APS).</p>
		<p>Em caso de d&uacute;vida, ligue para o <b>156</b> com qualquer telefone de Porto Alegre - RS ou (51) 3289-0156, op&ccedil;&atilde;o 9.</p>
		</center>
	</div>
</div> <!-- /jumbotron -->

<!-- formulario -->
	<div class="container">
		<center>
		<form class="navbar-form" role="form" action="./#resultado">
			<div class="form-group">
				<input type="text" name="rua" placeholder="Nome da rua" class="form-control" value="${rua}">
			</div>
<!--
			<div class="form-group">
				<input type="text" placeholder="Número" class="form-control">
			</div>
-->
			<button type="submit" class="btn btn-success">Buscar</button>
		</form>

		</center>
	</div> <!-- /container -->
<!-- /formulario -->
EOF

my @{resultados};

if (${sth}->fetchrow_array) {
print <<EOF;
<!-- resultado -->
<a name="resultado"></a>
<div class="separador">&nbsp;</div>
<div class="container">
	<h2>Quem mora na(o)...</h2>
EOF

	while ( @{resultados} = ${sth}->fetchrow_array ) {
		print <<EOF;
	<div class="row">
		<div class="col-xs-12 col-md-8">${resultados[1]} ${resultados[2]} ${resultados[3]} do número ${resultados[4]} até o ${resultados[5]}, deve ir na(o) </div>
		<div class="col-xs-6 col-md-4">${resultados[6]}.</div>
	</div>
<!-- /resultado -->
EOF

	}
} else {
	print <<EOF;
<div class="container">
	<h1>Nenhum resultado.</h1>
</div>
EOF
}

print <<EOF;
	<hr>

</div> <!-- /container -->


<div class="container">
	<div class="row">
		<div class="col-md-4">
			<h2>Hackathon DataPoa</h2>
			<p>Mussum ipsum cacilds, vidis litro abertis. Consetis adipiscings elitis. Pra lá , depois divoltis porris, paradis. Paisis, filhis, espiritis santis. Mé faiz elementum girarzis, nisi eros vermeio, in elementis mé pra quem é amistosis quis leo. Manduma pindureta quium dia nois paga. Sapien in monti palavris qui num significa nadis i pareci latim. Interessantiss quisso pudia ce receita de bolis, mais bolis eu num gostis.</p>
			<p><a class="btn btn-default" href="#" role="button">Bot&atilde;o &raquo;</a></p>
		</div>
		<div class="col-md-4">
			<h2>Conhe&ccedil;a o Matehackers</h2>
			<p>Suco de cevadiss, é um leite divinis, qui tem lupuliz, matis, aguis e fermentis. Interagi no mé, cursus quis, vehicula ac nisi. Aenean vel dui dui. Nullam leo erat, aliquet quis tempus a, posuere ut mi. Ut scelerisque neque et turpis posuere pulvinar pellentesque nibh ullamcorper. Pharetra in mattis molestie, volutpat elementum justo. Aenean ut ante turpis. Pellentesque laoreet mé vel lectus scelerisque interdum cursus velit auctor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ac mauris lectus, non scelerisque augue. Aenean justo massa.</p>
			<p><a class="btn btn-default" href="#" role="button">Bot&atilde;o &raquo;</a></p>
	 </div>
		<div class="col-md-4">
			<h2>Colabore com o software livre</h2>
			<p>Casamentiss faiz malandris se pirulitá, Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer Ispecialista im mé intende tudis nuam golada, vinho, uiski, carirí, rum da jamaikis, só num pode ser mijis. Adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.</p>
			<p><a class="btn btn-default" href="#" role="button">Bot&atilde;o &raquo;</a></p>
		</div>
</div> <!-- /container -->

<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>

	<hr>

	<footer>
		<p>&copy;left Matehackers 2014</p>
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

