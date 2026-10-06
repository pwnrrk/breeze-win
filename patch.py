#!/usr/bin/env python3
"""Patch upstream Breeze kdecoration: Windows-style min/max glyphs + rename plugin."""
import json, re, sys
d = sys.argv[1]

p = f'{d}/breezebutton.cpp'
s = open(p).read()
a = s.index('        case DecorationButtonType::Maximize: {\n            if (isChecked())')
b = s.index('        case DecorationButtonType::OnAllDesktops')
new = '''        case DecorationButtonType::Maximize: {
            pen.setJoinStyle(Qt::MiterJoin);
            pen.setCapStyle(Qt::SquareCap);
            painter->setPen(pen);
            if (isChecked()) {
                painter->drawRect(QRectF(3.5, 6.5, 8, 8));
                painter->drawPolyline(QVector<QPointF>{QPointF(6.5, 6.5), QPointF(6.5, 3.5), QPointF(14.5, 3.5), QPointF(14.5, 11.5), QPointF(11.5, 11.5)});
            } else {
                painter->drawRect(QRectF(4.5, 4.5, 9, 9));
            }
            break;
        }

        case DecorationButtonType::Minimize: {
            pen.setCapStyle(Qt::SquareCap);
            painter->setPen(pen);
            painter->drawLine(QPointF(4, 9.5), QPointF(14, 9.5));
            break;
        }

'''
open(p, 'w').write(s[:a] + new + s[b:])

p = f'{d}/breezedecoration.cpp'
s = open(p).read()
s2 = s.replace('"breeze.json"', '"breezewin.json"')
assert s != s2
open(p, 'w').write(s2)

j = json.load(open(f'{d}/breeze.json'))
kp = j['KPlugin']
j['KPlugin'] = {k: v for k, v in kp.items() if not re.match(r'(Name|Description)\[', k)}
j['KPlugin'].update(Id='org.kde.breezewin', Name='Breeze Win',
                    Description='Breeze window decoration with Windows-style minimize/maximize buttons')
json.dump(j, open(f'{d}/breezewin.json', 'w'), indent=4)
