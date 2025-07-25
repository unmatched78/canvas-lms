/*
 * Copyright (C) 2025 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import React from 'react'
import {Text} from '@instructure/ui-text'
import {useScope as createI18nScope} from '@canvas/i18n'

const I18n = createI18nScope('LearningMasteryGradebook')

interface TotalStudentTextProps {
  totalCount: number
}

export const TotalStudentText: React.FC<TotalStudentTextProps> = ({totalCount}) => {
  return (
    <Text>
      {I18n.t(
        {
          one: '%{count} student, ',
          other: '%{count} students, ',
          zero: 'No students, ',
        },
        {count: totalCount},
      )}
    </Text>
  )
}
