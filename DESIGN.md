# Design System Strategy: The Mischief Machine

## 1. Overview & Creative North Star
**Creative North Star: "The Analog Chaos Engine"**

This design system is not a standard utility; it is a high-octane digital toy. It moves away from the "flat" web aesthetic to embrace a maximalist, tactile experience that feels like a physical prank gadget found in a forbidden shop. We reject the sterile, symmetrical grid in favor of **Intentional Asymmetry**. 

The goal is to make the user feel like they are operating a piece of "glitchy" but premium hardware. We achieve this through overlapping elements, aggressive typography scales, and a "vibration" created by high-contrast color pairings. This isn't just an interface; it's a trigger for chaos.

---

## 2. Colors: High-Voltage Contrast
The palette is built on a foundation of "Void Black" (`#0e0e0e`) to allow our three "Hazard" accents to scream off the screen.

*   **Primary (Neon Green):** `primary` (#ddffae) / `primary_container` (#a5fd00). This is our "Go" signal. Use it for the most obnoxious, high-priority prank triggers.
*   **Secondary (Electric Purple):** `secondary` (#d873ff) / `secondary_container` (#9900ce). Represents the mysterious and the "Joker" spirit. Use for navigation and mode shifts.
*   **Tertiary (Hazard Orange):** `tertiary` (#ff7e3f) / `tertiary_container` (#fe6500). Reserved for "Warning" or "Extreme" sounds.

### The "No-Line" Rule
**Borders are forbidden.** We do not use 1px solid lines to separate content. Instead, use:
*   **Background Shifts:** Transition from `surface` to `surface_container_low` to define a section.
*   **Edge Glitch:** Use a 2px offset "shadow" of `primary` or `secondary` to define a button's edge, mimicking a physical plastic molding.

### Surface Hierarchy & Nesting
Treat the screen like a tiered circuit board.
*   **Base:** `surface_dim` (#0e0e0e).
*   **Modules:** `surface_container` (#1a1919) for sound category cards.
*   **Active Triggers:** `surface_bright` (#2c2c2c) for buttons that are currently "armed."

### Signature Textures
Apply a subtle linear gradient to main CTA buttons: `primary` transitioning to `primary_container` at a 135-degree angle. This gives the "plastic" a sheen that flat color cannot replicate.

---

## 3. Typography: Punchy & Brutalist
We use a dual-font system to balance "Mischief" with "Readability."

*   **Display & Headlines (Space Grotesk):** This is our "loud" voice. It’s wide, technical, and aggressive. 
    *   *Usage:* Use `display-lg` for category titles. Don't be afraid to let letters slightly overlap or use `headline-lg` with a -2% letter spacing for a "crushed" look.
*   **Body & Titles (Manrope):** Our "functional" voice. It provides the technical data for the gadget.
    *   *Usage:* Use `body-md` for sound descriptions. Keep it clean to contrast the chaotic headlines.

---

## 4. Elevation & Depth: Tonal Layering
Traditional shadows are too "soft" for this system. We use **Tactile Layering**.

*   **The Layering Principle:** To lift a sound-pad, place a `surface_container_highest` (#262626) element on top of a `surface_container_low` (#131313) background. The contrast in value creates the lift.
*   **The "Ghost Border":** If a button needs more definition against a dark background, use `outline_variant` (#484847) at **15% opacity**. It should be felt, not seen.
*   **Glassmorphism:** Use for "Pop-up Hazard" warnings. Apply `surface_container_high` at 60% opacity with a **20px Backdrop Blur**. This makes the warning feel like it’s floating over the dashboard.
*   **The Press Effect:** When a button is tapped, it should shift from `surface_bright` to `surface_container_lowest` (#000000) and lose its "outer glow," mimicking a physical button being pushed into a socket.

---

## 5. Components

### The "Trigger" (Buttons)
*   **Primary:** High-gloss. Background: `primary`. Text: `on_primary`. Shape: `md` (0.375rem). Use a "hard shadow" (0% blur) of `primary_fixed` at 4px offset for a 3D effect.
*   **Secondary:** Background: `secondary_container`. Text: `on_secondary_container`.

### The "Dial" (Selection Chips)
*   Use `surface_variant` (#262626) for inactive states. 
*   Active states should "glow" using `tertiary_dim` (#ff742d) text and a `tertiary_container` background.

### Sound Cards (Lists & Grids)
*   **Forbid Dividers.** Separate sounds using `surface_container_low` cards with `xl` (0.75rem) vertical spacing.
*   **Asymmetry:** Occasionally tilt a card by 1 or 2 degrees to break the "perfect" digital grid and lean into the chaotic "Joker" theme.

### "Live" Indicators (Input Fields)
*   Text inputs should look like digital readouts. Use `surface_container_lowest` for the field background and `primary` for the input text.
*   **Error State:** Use `error` (#ff7351) with a rapid 0.1s "jitter" animation.

---

## 6. Do's and Don'ts

### Do:
*   **DO** use extreme type scales. A `display-lg` title next to a `label-sm` technical note creates a professional, editorial look.
*   **DO** embrace "Vibrant Discord." Pairing `primary` (Neon Green) and `secondary` (Purple) creates visual energy suitable for a prank app.
*   **DO** use 100% black (`#000000`) for deep inset areas to create the illusion of physical holes in the UI.

### Don't:
*   **DON'T** use soft, rounded "pills" (full radius) for everything. Stick to `md` and `lg` roundedness to keep the gadget feeling "industrial."
*   **DON'T** use grey shadows. If you need a glow, use the `primary` or `secondary` token at 10% opacity with a large blur.
*   **DON'T** align everything perfectly to the center. Use "Power Aligned" layouts—everything slammed to the far left or far right—to create tension.

---

**Director's Final Note:** 
This system should feel like it's vibrating. Every tap should feel like a physical click, and every color should feel like a warning. If it feels "safe," you're doing it wrong. Push the chaos.