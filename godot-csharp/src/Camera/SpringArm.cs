using Godot;
using System.Diagnostics;

// Control the zoom of the camera with 'zoom', a value between 0 and 1
public class SpringArm : Godot.SpringArm
{

    Vector2 lengthRange = new Vector2(3.0f, 6.0f);
    float zoom = 0.5f;
    public Vector3 _positionStart;

    [Export]
    public Vector2 LengthRange
    {
        get { return lengthRange; }
        set
        {
            value.x = Mathf.Max(value.x, 0.0f);
            value.y = Mathf.Max(value.y, 0.0f);
            lengthRange.x = Mathf.Min(value.x, value.y);
            lengthRange.y = Mathf.Min(value.x, value.y);
            // set zoom again
            this.Zoom = zoom;
        }
    }

    [Export]
    public float Zoom {
        get {        return zoom;}
        set {
            Debug.Assert((value >= 0.0) && (value <= 1.0f));
            zoom = value;
            SpringLength = lengthRange.y + lengthRange.x - Mathf.Lerp(lengthRange.x, lengthRange.y, zoom);
        }
    }

    public override void _Ready()
    {
        _positionStart = Translation;
    }
}
