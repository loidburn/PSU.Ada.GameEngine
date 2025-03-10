
package body ECS.System.Render is 
   -- Draw the entity to the screen
   procedure Execute (Self       : in out Render_T;
                      Dt         : Duration;
                      Manager    : access Entity_Manager_T'Class ) is
   begin
      for Entity of Manager.all.Entities loop
         declare
            Trans       : Component_Access   :=    Entity.all.Get_Component(Transform_T'Tag);
            Circle      : Component_Access   :=    Entity.all.Get_Component(Circle_T'Tag);
            Quad        : Component_Access   :=    Entity.all.Get_Component(Quad_T'Tag);
         begin
            if Trans = null and Circle = null and Quad = null then
               Put_Line("Entity missing essential components");
               return;
            end if;
            if Trans /= null and Circle /= null then
               declare
                  T renames Transform_T(Trans.all);
                  C renames Circle_T(Circle.all);
               begin
                  Draw_Regular_Polygon(Self.Buffer.all, C.Sides, C.Radius, T.Position.X,T.Position.Y, C.C, Self.Width, Self.Height);
               end;
            elsif Trans /= null and Quad /= null then
               declare
                  T renames Transform_T(Trans.all);
                  Q renames Quad_T(Quad.all);
               begin
                  Draw_Filled_Quad (Self.Buffer.all,T.Position.X, T.Position.Y, Q.Width, Q.Height, Q.C,Self.Width, Self.Height);
               end;
            else
               Put_Line("Entity missing essential components");
            end if;
         end;
      end loop; 
   end Execute;
end ECS.System.Render;