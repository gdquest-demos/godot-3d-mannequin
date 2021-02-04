using Godot;
using System.Threading.Tasks;

public class PlayerState : State
{
    protected Player _player = null;
    protected Mannequiny _skin = null;
    public override void _Ready()
    {
        base._Ready();
        WaitForParentNode();
    }


    // Waiting for the owner node to be ready
    private async void WaitForParentNode()
    {
        await ToSignal(Owner, "ready");
         
         
        _player = (Owner as Player);
        
        _skin = ((Owner as Player).skin);

        if ((_player == null)) GD.PushError("_player reference is null!");
        if ((_skin == null)) GD.PushError("_player.skin reference is null!");
    }
}
