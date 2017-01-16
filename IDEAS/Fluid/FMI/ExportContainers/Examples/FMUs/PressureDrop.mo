within IDEAS.Fluid.FMI.ExportContainers.Examples.FMUs;
block PressureDrop
  "Declaration of an FMU that exports a fixed resistance"
   extends IDEAS.Fluid.FMI.ExportContainers.ReplaceableTwoPort(
     redeclare replaceable package Medium = IDEAS.Media.Air, redeclare final
      IDEAS.Fluid.FixedResistances.PressureDrop com(final m_flow_nominal=
          m_flow_nominal, final dp_nominal=if use_p_in then dp_nominal else 0));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.01
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=100
    "Pressure drop at nominal mass flow rate";
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://IDEAS.Fluid.FixedResistances.PressureDrop\">
IDEAS.Fluid.FixedResistances.PressureDrop</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/PressureDrop.mos"
        "Export FMU"),
    Icon(graphics={
        Rectangle(
          extent={{-64,24},{70,-26}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,14},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder)}));
end PressureDrop;
