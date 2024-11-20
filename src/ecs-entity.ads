with ecs.component; use ecs.component;
with Ada.Tags; use Ada.Tags;
with Ada.Containers.Vectors;


package ecs.entity is 

    subtype Id_T is String (1 .. 5);
    package Component_List is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Component_Access);
    use Component_List;
    type Entity_T (Count : Positive) is tagged record
        Id         : Id_T;
        Components : Component_List.Vector;
        Destroyed  : Boolean;
    end record;

    type Entity_Access is access all Entity_T'Class;
    type Entities_T    is array (Natural range <>) of Entity_Access;

    function Get_Component (E : Entity_T'Class; Tag : Ada.Tags.Tag) return Component_Access;
    procedure Add_Component(E: in out Entity_T'Class; Component: Component_Access);
end ecs.entity;