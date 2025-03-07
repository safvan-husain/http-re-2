const fs = require("fs");
const path = require("path");

async function createThatXmlIfNotExist() {
  return new Promise((resolve, reject) => {
    const targetDirectory = path.join(
      process.cwd(),
      "Recovery",
      "build",
      "app",
      "intermediates",
      "merged-not-compiled-resources",
      "release",
      "layout",
    );

    const targetPath = path.join(
      targetDirectory,
      "notification_template_custom_big.xml",
    );

    // Check if the directory exists, if not, create it
    fs.access(targetDirectory, fs.constants.F_OK, (dirErr) => {
      if (dirErr) {
        console.log(`Directory ${targetDirectory} does not exist. Creating...`);
        fs.mkdir(targetDirectory, { recursive: true }, (mkdirErr) => {
          if (mkdirErr) {
            reject(`Error creating directory ${targetDirectory}: ${mkdirErr}`);
            console.error(`Error creating directory: ${mkdirErr}`);
            return;
          }
          console.log(`Directory ${targetDirectory} created.`);
          createFile();
        });
      } else {
        createFile();
      }
    });

    function createFile() {
      // Now, the directory exists, proceed to check and create the file
      fs.access(targetPath, fs.constants.F_OK, (err) => {
        if (err) {
          console.log(`File ${targetPath} does not exist. Creating...`);
          const content = `<?xml version="1.0" encoding="utf-8"?>
<!--
Copyright (C) 2012 The Android Open Source Project
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android" xmlns:internal="http://schemas.android.com/apk/prv/res/android" android:background="@android:drawable/notification_bg" android:id="@+id/status_bar_latest_event_content" android:layout_width="match_parent" android:layout_height="wrap_content" internal:layout_minHeight="65dp" internal:layout_maxHeight="unbounded">
<ImageView android:id="@+id/icon" android:layout_width="@dimen/notification_large_icon_width" android:layout_height="@dimen/notification_large_icon_height" android:background="@android:drawable/notification_template_icon_bg" android:scaleType="center" />
<LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_gravity="fill_vertical" android:minHeight="@dimen/notification_large_icon_height" android:orientation="vertical" android:gravity="top">
<LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="@dimen/notification_large_icon_width" android:minHeight="@dimen/notification_large_icon_height" android:paddingTop="2dp" android:orientation="vertical">
<LinearLayout android:id="@+id/line1" android:layout_width="match_parent" android:layout_height="wrap_content" android:paddingTop="6dp" android:layout_marginEnd="8dp" android:layout_marginStart="8dp" android:orientation="horizontal">
<TextView android:id="@+id/title" android:textAppearance="@style/TextAppearance.StatusBar.EventContent.Title" android:layout_width="match_parent" android:layout_height="wrap_content" android:singleLine="true" android:ellipsize="marquee" android:fadingEdge="horizontal" android:layout_weight="1" />
<ViewStub android:id="@+id/time" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_weight="0" android:visibility="gone" android:layout="@layout/notification_template_part_time" />
<ViewStub android:id="@+id/chronometer" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_weight="0" android:visibility="gone" android:layout="@layout/notification_template_part_chronometer" />
</LinearLayout>
<TextView android:id="@+id/text2" android:textAppearance="@style/TextAppearance.StatusBar.EventContent.Line2" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="-2dp" android:layout_marginBottom="-2dp" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:singleLine="true" android:fadingEdge="horizontal" android:ellipsize="marquee" android:visibility="gone" />
<TextView android:id="@+id/big_text" android:textAppearance="@style/TextAppearance.StatusBar.EventContent" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:singleLine="false" android:visibility="gone" />
<LinearLayout android:id="@+id/line3" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:orientation="horizontal" android:gravity="center_vertical">
<TextView android:id="@+id/text" android:textAppearance="@style/TextAppearance.StatusBar.EventContent" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:layout_gravity="center" android:singleLine="true" android:ellipsize="marquee" android:fadingEdge="horizontal" />
<TextView android:id="@+id/info" android:textAppearance="@style/TextAppearance.StatusBar.EventContent.Info" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_gravity="center" android:layout_weight="0" android:singleLine="true" android:gravity="center" android:paddingStart="8dp" />
<ImageView android:id="@+id/right_icon" android:layout_width="16dp" android:layout_height="16dp" android:layout_gravity="center" android:layout_weight="0" android:layout_marginStart="8dp" android:scaleType="centerInside" android:visibility="gone" android:drawableAlpha="153" />
</LinearLayout>
<ProgressBar android:id="@android:id/progress" android:layout_width="match_parent" android:layout_height="12dp" android:layout_marginBottom="8dp" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:visibility="gone" style="?android:attr/progressBarStyleHorizontal" />
</LinearLayout>
<ImageView android:layout_width="match_parent" android:layout_height="1px" android:id="@+id/action_divider" android:visibility="gone" android:background="?android:attr/dividerHorizontal" />
<include layout="@layout/notification_action_list" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="@dimen/notification_large_icon_width" />
</LinearLayout>
</FrameLayout>
`;
          fs.writeFile(targetPath, content, (writeErr) => {
            if (writeErr) {
              reject(`Error creating file ${targetPath}: ${writeErr}`);
              console.error(`Error creating file: ${writeErr}`);
            } else {
              resolve("File created");
              console.log(`File ${targetPath} has been created.`);
            }
          });
        } else {
          resolve("File exists");
          console.log(`File ${targetPath} exists.`);
        }
      });
    }
  });
}

module.exports = { createThatXmlIfNotExist };

// async function createThatXmlIfNotExis() {
//   return new Promise((resolve, reject) => {
//     const targetPath = path.join(
//       process.cwd(),
//       "Recovery",
//       "build",
//       "app",
//       "intermediates",
//       "merged-not-compiled-resources",
//       "release",
//       "layout",
//       "notification_template_custom_big.xml",
//     );
//
//     fs.access(targetPath, fs.constants.F_OK, (err) => {
//       if (err) {
//         console.log(`File ${targetPath} does not exist.`);
//         const content = `<?xml version="1.0" encoding="utf-8"?>
// <!--
// Copyright (C) 2012 The Android Open Source Project
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -->
// <FrameLayout xmlns:android="http://schemas.android.com/apk/res/android" xmlns:internal="http://schemas.android.com/apk/prv/res/android" android:background="@android:drawable/notification_bg" android:id="@+id/status_bar_latest_event_content" android:layout_width="match_parent" android:layout_height="wrap_content" internal:layout_minHeight="65dp" internal:layout_maxHeight="unbounded">
// <ImageView android:id="@+id/icon" android:layout_width="@dimen/notification_large_icon_width" android:layout_height="@dimen/notification_large_icon_height" android:background="@android:drawable/notification_template_icon_bg" android:scaleType="center" />
// <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_gravity="fill_vertical" android:minHeight="@dimen/notification_large_icon_height" android:orientation="vertical" android:gravity="top">
// <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="@dimen/notification_large_icon_width" android:minHeight="@dimen/notification_large_icon_height" android:paddingTop="2dp" android:orientation="vertical">
// <LinearLayout android:id="@+id/line1" android:layout_width="match_parent" android:layout_height="wrap_content" android:paddingTop="6dp" android:layout_marginEnd="8dp" android:layout_marginStart="8dp" android:orientation="horizontal">
// <TextView android:id="@+id/title" android:textAppearance="@style/TextAppearance.StatusBar.EventContent.Title" android:layout_width="match_parent" android:layout_height="wrap_content" android:singleLine="true" android:ellipsize="marquee" android:fadingEdge="horizontal" android:layout_weight="1" />
// <ViewStub android:id="@+id/time" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_weight="0" android:visibility="gone" android:layout="@layout/notification_template_part_time" />
// <ViewStub android:id="@+id/chronometer" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_weight="0" android:visibility="gone" android:layout="@layout/notification_template_part_chronometer" />
// </LinearLayout>
// <TextView android:id="@+id/text2" android:textAppearance="@style/TextAppearance.StatusBar.EventContent.Line2" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="-2dp" android:layout_marginBottom="-2dp" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:singleLine="true" android:fadingEdge="horizontal" android:ellipsize="marquee" android:visibility="gone" />
// <TextView android:id="@+id/big_text" android:textAppearance="@style/TextAppearance.StatusBar.EventContent" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:singleLine="false" android:visibility="gone" />
// <LinearLayout android:id="@+id/line3" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:orientation="horizontal" android:gravity="center_vertical">
// <TextView android:id="@+id/text" android:textAppearance="@style/TextAppearance.StatusBar.EventContent" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:layout_gravity="center" android:singleLine="true" android:ellipsize="marquee" android:fadingEdge="horizontal" />
// <TextView android:id="@+id/info" android:textAppearance="@style/TextAppearance.StatusBar.EventContent.Info" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_gravity="center" android:layout_weight="0" android:singleLine="true" android:gravity="center" android:paddingStart="8dp" />
// <ImageView android:id="@+id/right_icon" android:layout_width="16dp" android:layout_height="16dp" android:layout_gravity="center" android:layout_weight="0" android:layout_marginStart="8dp" android:scaleType="centerInside" android:visibility="gone" android:drawableAlpha="153" />
// </LinearLayout>
// <ProgressBar android:id="@android:id/progress" android:layout_width="match_parent" android:layout_height="12dp" android:layout_marginBottom="8dp" android:layout_marginStart="8dp" android:layout_marginEnd="8dp" android:visibility="gone" style="?android:attr/progressBarStyleHorizontal" />
// </LinearLayout>
// <ImageView android:layout_width="match_parent" android:layout_height="1px" android:id="@+id/action_divider" android:visibility="gone" android:background="?android:attr/dividerHorizontal" />
// <include layout="@layout/notification_action_list" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginStart="@dimen/notification_large_icon_width" />
// </LinearLayout>
// </FrameLayout>
// `;
//
//         fs.writeFile(targetPath, content, (writeErr) => {
//           if (writeErr) {
//             reject(`Error creating file ${writeErr}`);
//             console.error(`Error creating file: ${writeErr}`);
//           } else {
//             resolve("file created");
//             console.log(`File ${targetPath} has been created.`);
//           }
//         });
//       } else {
//         resolve();
//         console.log(`File ${targetPath} exists.`);
//       }
//     });
//   });
// }

// createThatXmlIfNotExist();
