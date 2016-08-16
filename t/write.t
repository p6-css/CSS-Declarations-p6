use v6;
use Test;
use CSS::Declarations;

my $css = CSS::Declarations.new( :style("border-style: groove!important") );
is $css.write(:!optimize), "border-bottom-style:groove!important; border-left-style:groove!important; border-right-style:groove!important; border-top-style:groove!important;", "unoptimized edge property";
is $css.write, "border-style:groove!important;", "edge property";

$css = CSS::Declarations.new( :style("margin-top: 1pt; margin-left: 1pt; margin-bottom: 1pt; margin-right: 1pt;") );
is $css.write, "margin:1pt;", "consolidation of edge properties";

$css = CSS::Declarations.new( :style("margin-bottom: 1pt; margin-left: 2pt; margin-right: 3pt; margin-top: 4pt;") );
is $css.write, "margin-bottom:1pt; margin-left:2pt; margin-right:3pt; margin-top:4pt;", "consolidation of edge properties";

$css = CSS::Declarations.new( :style("border-color: rgb(255,0,0); border-width: 2pt") );
is $css.write, "border:2pt red;", "optimized properties";

$css = CSS::Declarations.new( :style("margin: inherit") );
is $css.write(:!optimize), "margin-bottom:inherit; margin-left:inherit; margin-right:inherit; margin-top:inherit;", "edge unoptimized";
is $css.write, "margin:inherit;", "edge optimized";

$css = CSS::Declarations.new( :style("border: red solid 1px"));
is $css.write, "border:1px solid red;", "compound edge";
my Str $style = $css.write(:!optimize);
is $style, "border-bottom-color:red; border-bottom-style:solid; border-bottom-width:1px; border-left-color:red; border-left-style:solid; border-left-width:1px; border-right-color:red; border-right-style:solid; border-right-width:1px; border-top-color:red; border-top-style:solid; border-top-width:1px;", "compound edge - unoptimized";
is CSS::Declarations.new( :$style ).write, "border:1px solid red;", "compound edge - re-optimized";

$css = CSS::Declarations.new( :style("$style; border-top-width: 2px; border-top-color: rgb(255,0,0)") );
is $css.write, "border:solid red; border-bottom-width:1px; border-left-width:1px; border-right-width:1px; border-top-width:2px;", "compound edge - partial optimization";

$css = CSS::Declarations.new( :style("margin-top: 0; margin-right: 0mm; margin-left: 2pt") );
is  $css.write, "margin-left:2pt;", "optimization of default values";

$css = CSS::Declarations.new( :style("cue-before: url(foo)") );
is  $css.write, "cue-before:url('foo');";

$css = CSS::Declarations.new( :style("cue-before: url(foo); cue-after: url(bar)") );
is  $css.write, "cue:url('foo') url('bar');";

$css = CSS::Declarations.new( :style("cue-after: url('bar')") );
is  $css.write, "cue-after:url('bar');";

$css = CSS::Declarations.new( :style("font-weight:bold; font-family:Helvetica") );
is  $css.write, "font-family:Helvetica; font-weight:bold;";

$css = CSS::Declarations.new( :style("font-weight:bold; font-size: 12pt; font-family:Helvetica") );
is  $css.write, "font:bold 12pt Helvetica;";

done-testing;